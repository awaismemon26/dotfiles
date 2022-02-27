"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ClientHandler = void 0;
const short_unique_id_1 = require("short-unique-id");
const vscode = require("vscode");
const node_1 = require("vscode-languageclient/node");
const showReferences_1 = require("./showReferences");
const telemetry_1 = require("./telemetry");
const vscodeUtils_1 = require("./vscodeUtils");
/**
 * ClientHandler maintains lifecycles of language clients
 * based on the server's capabilities
 */
class ClientHandler {
    constructor(lsPath, outputChannel, reporter) {
        this.lsPath = lsPath;
        this.outputChannel = outputChannel;
        this.reporter = reporter;
        this.shortUid = new short_unique_id_1.default();
        this.commands = [];
        if (lsPath.hasCustomBinPath()) {
            this.reporter.sendTelemetryEvent('usePathToBinary');
        }
    }
    async startClient() {
        console.log('Starting client');
        this.tfClient = await this.createTerraformClient();
        const disposable = this.tfClient.client.start();
        await this.tfClient.client.onReady();
        this.reporter.sendTelemetryEvent('startClient');
        const initializeResult = this.tfClient.client.initializeResult;
        if (initializeResult !== undefined) {
            const multiFoldersSupported = initializeResult.capabilities.workspace?.workspaceFolders?.supported;
            console.log(`Multi-folder support: ${multiFoldersSupported}`);
            this.commands = initializeResult.capabilities.executeCommandProvider?.commands ?? [];
        }
        return disposable;
    }
    async createTerraformClient() {
        const commandPrefix = this.shortUid.seq();
        const initializationOptions = this.getInitializationOptions(commandPrefix);
        const serverOptions = await this.getServerOptions();
        const documentSelector = [
            { scheme: 'file', language: 'terraform' },
            { scheme: 'file', language: 'terraform-vars' },
        ];
        const clientOptions = {
            documentSelector: documentSelector,
            initializationOptions: initializationOptions,
            initializationFailedHandler: (error) => {
                this.reporter.sendTelemetryException(error);
                return false;
            },
            outputChannel: this.outputChannel,
            revealOutputChannelOn: node_1.RevealOutputChannelOn.Never,
        };
        const id = `terraform`;
        const client = new node_1.LanguageClient(id, serverOptions, clientOptions);
        const codeLensReferenceCount = (0, vscodeUtils_1.config)('terraform').get('codelens.referenceCount');
        if (codeLensReferenceCount) {
            client.registerFeature(new showReferences_1.ShowReferencesFeature(client));
        }
        if (vscode.env.isTelemetryEnabled) {
            client.registerFeature(new telemetry_1.TelemetryFeature(client, this.reporter));
        }
        client.onDidChangeState((event) => {
            console.log(`Client: ${node_1.State[event.oldState]} --> ${node_1.State[event.newState]}`);
            if (event.newState === node_1.State.Stopped) {
                this.reporter.sendTelemetryEvent('stopClient');
            }
        });
        return { commandPrefix, client };
    }
    async getServerOptions() {
        const cmd = await this.lsPath.resolvedPathToBinary();
        const serverArgs = (0, vscodeUtils_1.config)('terraform').get('languageServer.args', []);
        const executable = {
            command: cmd,
            args: serverArgs,
            options: {},
        };
        const serverOptions = {
            run: executable,
            debug: executable,
        };
        this.outputChannel.appendLine(`Launching language server: ${cmd} ${serverArgs.join(' ')}`);
        return serverOptions;
    }
    getInitializationOptions(commandPrefix) {
        const rootModulePaths = (0, vscodeUtils_1.config)('terraform-ls').get('rootModules', []);
        const terraformExecPath = (0, vscodeUtils_1.config)('terraform-ls').get('terraformExecPath', '');
        const terraformExecTimeout = (0, vscodeUtils_1.config)('terraform-ls').get('terraformExecTimeout', '');
        const terraformLogFilePath = (0, vscodeUtils_1.config)('terraform-ls').get('terraformLogFilePath', '');
        const excludeModulePaths = (0, vscodeUtils_1.config)('terraform-ls').get('excludeRootModules', []);
        const ignoreDirectoryNames = (0, vscodeUtils_1.config)('terraform-ls').get('ignoreDirectoryNames', []);
        if (rootModulePaths.length > 0 && excludeModulePaths.length > 0) {
            throw new Error('Only one of rootModules and excludeRootModules can be set at the same time, please remove the conflicting config and reload');
        }
        const experimentalFeatures = (0, vscodeUtils_1.config)('terraform-ls').get('experimentalFeatures');
        const initializationOptions = {
            commandPrefix,
            experimentalFeatures,
            ...(terraformExecPath.length > 0 && { terraformExecPath }),
            ...(terraformExecTimeout.length > 0 && { terraformExecTimeout }),
            ...(terraformLogFilePath.length > 0 && { terraformLogFilePath }),
            ...(rootModulePaths.length > 0 && { rootModulePaths }),
            ...(excludeModulePaths.length > 0 && { excludeModulePaths }),
            ...(ignoreDirectoryNames.length > 0 && { ignoreDirectoryNames }),
        };
        return initializationOptions;
    }
    async stopClient() {
        if (this.tfClient?.client === undefined) {
            return;
        }
        await this.tfClient.client.stop();
        console.log('Client stopped');
    }
    getClient() {
        return this.tfClient;
    }
    clientSupportsCommand(cmdName) {
        return this.commands.includes(cmdName);
    }
}
exports.ClientHandler = ClientHandler;
//# sourceMappingURL=clientHandler.js.map