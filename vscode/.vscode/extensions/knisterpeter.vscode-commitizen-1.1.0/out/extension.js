"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = void 0;
const child_process_1 = require("child_process");
const execa_1 = __importDefault(require("execa"));
const path_1 = require("path");
const sander = __importStar(require("sander"));
// tslint:disable-next-line:no-implicit-dependencies
const vscode = __importStar(require("vscode"));
const wrap_ansi_1 = __importDefault(require("wrap-ansi"));
let channel;
function getConfiguration() {
    const config = vscode.workspace
        .getConfiguration()
        .get('commitizen');
    return config;
}
function activate(context) {
    return __awaiter(this, void 0, void 0, function* () {
        channel = vscode.window.createOutputChannel('commitizen');
        channel.appendLine('Commitizen support started');
        context.subscriptions.push(vscode.commands.registerCommand('vscode-commitizen.commit', () => __awaiter(this, void 0, void 0, function* () {
            const lookupPath = yield findLookupPath();
            if (lookupPath) {
                const czConfig = yield readCzConfig(lookupPath);
                const ccm = new ConventionalCommitMessage(czConfig);
                yield ccm.getType();
                yield ccm.getScope();
                yield ccm.getSubject();
                yield ccm.getBody();
                yield ccm.getBreaking();
                yield ccm.getFooter();
                if (ccm.complete) {
                    yield commit(lookupPath, ccm.messages);
                }
            }
            else {
                channel.appendLine('Lookup path not found');
            }
        })));
    });
}
exports.activate = activate;
let gitRoot = undefined;
function findLookupPath() {
    return __awaiter(this, void 0, void 0, function* () {
        let ws = '';
        if (!vscode.workspace.workspaceFolders) {
            return undefined;
        }
        else if (vscode.workspace.workspaceFolders.length > 1) {
            const repositories = {};
            vscode.workspace.workspaceFolders.forEach((folder) => {
                repositories[folder.name] = {
                    label: folder.name,
                    description: folder.uri.fsPath
                };
            });
            const pickOptions = {
                placeHolder: 'Select a folder',
                ignoreFocusOut: true,
                matchOnDescription: true,
                matchOnDetail: true
            };
            const pick = yield vscode.window.showQuickPick(Object.values(repositories), pickOptions);
            if (pick) {
                ws = repositories[pick.label].description;
            }
        }
        else {
            ws = vscode.workspace.workspaceFolders[0].uri.fsPath;
        }
        if (getConfiguration().useGitRoot) {
            if (gitRoot === undefined) {
                gitRoot = yield new Promise((resolve, reject) => (0, child_process_1.exec)('git rev-parse --show-toplevel', { cwd: ws }, (err, stdout, stderr) => {
                    if (err) {
                        reject({ err, stderr });
                    }
                    else if (stdout) {
                        channel.appendLine(`Found git root at: ${stdout}`);
                        resolve(stdout.trim());
                    }
                    else {
                        reject({ err: 'Unable to find git root' });
                    }
                })).catch((e) => {
                    channel.appendLine(e.err.toString());
                    if (e.stderr) {
                        channel.appendLine(e.stderr.toString());
                    }
                    return undefined;
                });
            }
            return gitRoot;
        }
        return ws;
    });
}
function readCzConfig(lookupPath) {
    return __awaiter(this, void 0, void 0, function* () {
        let configPath = (0, path_1.join)(lookupPath, '.cz-config.js');
        if (yield sander.exists(configPath)) {
            return require(configPath);
        }
        const pkg = yield readPackageJson(lookupPath);
        if (!pkg) {
            return undefined;
        }
        configPath = (0, path_1.join)(lookupPath, '.cz-config.js');
        if (hasCzConfig(pkg)) {
            configPath = (0, path_1.join)(lookupPath, pkg.config['cz-customizable'].config);
        }
        if (!(yield sander.exists(configPath))) {
            return undefined;
        }
        return require(configPath);
    });
}
function readPackageJson(lookupPath) {
    return __awaiter(this, void 0, void 0, function* () {
        const pkgPath = (0, path_1.join)(lookupPath, 'package.json');
        if (!(yield sander.exists(pkgPath))) {
            return undefined;
        }
        return JSON.parse(yield sander.readFile(pkgPath));
    });
}
function hasCzConfig(pkg) {
    return (pkg.config &&
        pkg.config['cz-customizable'] &&
        pkg.config['cz-customizable'].config);
}
function askOneOf(question, picks, save, customLabel, customQuestion) {
    return __awaiter(this, void 0, void 0, function* () {
        const pickOptions = {
            placeHolder: question,
            ignoreFocusOut: true,
            matchOnDescription: true,
            matchOnDetail: true
        };
        const pick = yield vscode.window.showQuickPick(picks, pickOptions);
        if (pick && pick.label === customLabel && !!customQuestion) {
            const next = yield ask(customQuestion || '', (input) => {
                save({ label: input, description: '' });
                return true;
            });
            return next;
        }
        if (pick === undefined) {
            return false;
        }
        save(pick);
        return true;
    });
}
function ask(question, save, validate) {
    return __awaiter(this, void 0, void 0, function* () {
        const options = {
            placeHolder: question,
            ignoreFocusOut: true
        };
        if (validate) {
            options.validateInput = validate;
        }
        const input = yield vscode.window.showInputBox(options);
        if (input === undefined) {
            return false;
        }
        save(input);
        return true;
    });
}
const DEFAULT_TYPES = [
    {
        value: 'feat',
        name: 'A new feature'
    },
    {
        value: 'fix',
        name: 'A bug fix'
    },
    {
        value: 'docs',
        name: 'Documentation only changes'
    },
    {
        value: 'style',
        name: 'Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)'
    },
    {
        value: 'refactor',
        name: 'A code change that neither fixes a bug nor adds a feature'
    },
    {
        value: 'perf',
        name: 'A code change that improves performance'
    },
    {
        value: 'test',
        name: 'Adding missing tests or correcting existing tests'
    },
    {
        value: 'build',
        name: 'Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)'
    },
    {
        value: 'ci',
        name: 'Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)'
    },
    {
        value: 'chore',
        name: "Other changes that don't modify src or test files"
    }
];
const DEFAULT_MESSAGES = {
    type: "Select the type of change that you're committing",
    customScope: 'Denote the SCOPE of this change',
    customScopeEntry: 'Custom scope...',
    scope: 'Denote the SCOPE of this change (optional)',
    subject: 'Write a SHORT, IMPERATIVE tense description of the change',
    body: 'Provide a LONGER description of the change (optional). Use "|" to break new line',
    breaking: 'List any BREAKING CHANGES (optional)',
    footer: 'List any ISSUES CLOSED by this change (optional). E.g.: #31, #34'
};
const splitMessages = (message) => {
    const result = [];
    if (message.includes('|')) {
        message.split('|').forEach((msg) => {
            result.push('-m', `"${msg}"`);
        });
    }
    else {
        result.push('-m', `"${message}"`);
    }
    return result;
};
const buildCommitArguments = (message) => {
    const messageArguments = ['-m', `"${message.main}"`];
    if (message.body) {
        messageArguments.push(...splitMessages(message.body));
    }
    if (message.footer) {
        messageArguments.push(...splitMessages(message.footer));
    }
    const signArgument = getConfiguration().signCommits ? ['-S'] : [];
    return [...messageArguments, ...signArgument];
};
function commit(cwd, message) {
    return __awaiter(this, void 0, void 0, function* () {
        channel.appendLine(`About to commit '${message.main}'`);
        try {
            yield conditionallyStageFiles(cwd);
            const result = yield (0, execa_1.default)('git', ['commit', ...buildCommitArguments(message)], {
                cwd: getGitCwd(cwd),
                preferLocal: false,
                shell: getConfiguration().shell
            });
            if (getConfiguration().autoSync) {
                yield (0, execa_1.default)('git', ['sync'], { cwd });
            }
            if (hasOutput(result)) {
                result.stdout.split('\n').forEach((line) => channel.appendLine(line));
                if (shouldShowOutput(result)) {
                    channel.show();
                }
            }
        }
        catch (e) {
            vscode.window.showErrorMessage(e.message);
            channel.appendLine(e.message);
            channel.appendLine(e.stack);
        }
    });
}
function hasOutput(result) {
    return Boolean(result && result.stdout);
}
function shouldShowOutput(result) {
    return (getConfiguration().showOutputChannel === 'always' ||
        (getConfiguration().showOutputChannel === 'onError' && result.exitCode > 0));
}
function conditionallyStageFiles(cwd) {
    return __awaiter(this, void 0, void 0, function* () {
        const hasSmartCommitEnabled = vscode.workspace
            .getConfiguration('git')
            .get('enableSmartCommit') === true;
        if (hasSmartCommitEnabled && !(yield hasStagedFiles(cwd))) {
            channel.appendLine('Staging all files (enableSmartCommit enabled with nothing staged)');
            yield (0, execa_1.default)('git', ['add', '.'], {
                cwd
            });
        }
    });
}
function hasStagedFiles(cwd) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = yield (0, execa_1.default)('git', ['diff', '--name-only', '--cached'], {
            cwd
        });
        return hasOutput(result);
    });
}
class ConventionalCommitMessage {
    constructor(czConfig) {
        this.next = true;
        this.czConfig = czConfig;
    }
    static shouldSkip(czConfig, messageType) {
        return Boolean(czConfig &&
            czConfig.skipQuestions &&
            czConfig.skipQuestions.includes(messageType));
    }
    static hasScopes(czConfig) {
        return Boolean(czConfig && czConfig.scopes && czConfig.scopes.length !== 0);
    }
    static hasCustomMessage(czConfig, messageType) {
        return Boolean(czConfig &&
            czConfig.messages &&
            czConfig.messages.hasOwnProperty(messageType));
    }
    static getScopePicks(czConfig, allowCustomScopesLabel) {
        const scopePicks = czConfig.scopes.map((scope) => ({
            label: scope.name || scope,
            description: ''
        }));
        if (czConfig.allowCustomScopes) {
            scopePicks.push({
                label: allowCustomScopesLabel,
                description: ''
            });
        }
        return scopePicks;
    }
    static allowBreakingChanges(czConfig, selectedType) {
        if ((czConfig === null || czConfig === void 0 ? void 0 : czConfig.allowBreakingChanges) && selectedType) {
            return czConfig === null || czConfig === void 0 ? void 0 : czConfig.allowBreakingChanges.some((type) => type === selectedType);
        }
        return true;
    }
    getType() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.next) {
                const types = (this.czConfig && this.czConfig.types) || DEFAULT_TYPES;
                const typePicks = types.map((type) => ({
                    label: type.value,
                    description: type.name
                }));
                this.next = yield askOneOf(this.inputMessage('type'), typePicks, (pick) => (this.type = pick.label));
            }
        });
    }
    getScope() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.next && !ConventionalCommitMessage.shouldSkip(this.czConfig, 'scope')) {
                if (ConventionalCommitMessage.hasScopes(this.czConfig)) {
                    if (this.czConfig.scopes && this.czConfig.scopes[0] !== undefined) {
                        const scopePicks = ConventionalCommitMessage.getScopePicks(this.czConfig, this.inputMessage('customScopeEntry'));
                        this.next = yield askOneOf(this.inputMessage('customScope'), scopePicks, (pick) => {
                            this.scope = pick.label || undefined;
                        }, this.inputMessage('customScopeEntry'), this.inputMessage('customScope'));
                    }
                }
                else {
                    this.next = yield ask(this.inputMessage('scope'), (input) => (this.scope = input));
                }
            }
        });
    }
    getSubject() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.next) {
                const maxLength = getConfiguration().subjectLength;
                const validator = (input) => {
                    if (input.length === 0 || input.length > maxLength) {
                        return `Subject is required and must be less than ${maxLength} characters`;
                    }
                    return '';
                };
                this.next = yield ask(this.inputMessage('subject'), (input) => (this.subject = input), validator);
            }
        });
    }
    getBody() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.next &&
                !ConventionalCommitMessage.shouldSkip(this.czConfig, 'body')) {
                this.next = yield ask(this.inputMessage('body'), (input) => (this.body = (0, wrap_ansi_1.default)(input, 72, { hard: true })));
            }
        });
    }
    getBreaking() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.next &&
                !ConventionalCommitMessage.shouldSkip(this.czConfig, 'breaking') &&
                ConventionalCommitMessage.allowBreakingChanges(this.czConfig, this.type)) {
                this.next = yield ask(this.inputMessage('breaking'), (input) => (this.breaking = input));
            }
        });
    }
    getFooter() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.next &&
                !ConventionalCommitMessage.shouldSkip(this.czConfig, 'footer')) {
                this.next = yield ask(this.inputMessage('footer'), (input) => (this.footer = input));
            }
        });
    }
    get complete() {
        return this.next && Boolean(this.type) && Boolean(this.subject);
    }
    get messages() {
        const main = `${this.type}${typeof this.scope === 'string' && this.scope ?
            `(${this.scope})` : ''}: ${this.subject}`;
        const body = `${this.body}`;
        const footer = `${this.breaking ? `BREAKING CHANGE: ${this.breaking}|` : ''}${this.messageFooter()}`;
        return {
            main,
            body,
            footer
        };
    }
    messageFooter() {
        return this.footer
            ? `${this.czConfig && this.czConfig.footerPrefix
                ? this.czConfig.footerPrefix
                : 'Closes '}${this.footer}`
            : '';
    }
    inputMessage(messageType) {
        return ConventionalCommitMessage.hasCustomMessage(this.czConfig, messageType)
            ? this.czConfig.messages[messageType]
            : DEFAULT_MESSAGES[messageType];
    }
}
function capitalizeWindowsDriveLetter(path) {
    if (!path) {
        return path;
    }
    return path.replace(/(\w+?):/, (rootElement) => {
        return rootElement.toUpperCase();
    });
}
function getGitCwd(cwd) {
    let cwdForGit = cwd;
    if (getConfiguration().capitalizeWindowsDriveLetter) {
        cwdForGit = capitalizeWindowsDriveLetter(cwd);
    }
    return cwdForGit;
}
//# sourceMappingURL=extension.js.map