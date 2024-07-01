## Fullstack Rust with Leptos and Spin

<details><summary>Pre-requisites</summary>
<br>
First, ensure that you have Rust 'nightly' with both the `wasm` and `wasm32-wasi` targets, along with `cargo-generate`
- `rustup toolchain install nightly --allow-downgrade`
- `rustup target add wasm32-unknown-unknown`
- `rustup target add wasm32-wasi`
- `cargo install cargo-generate`

If you don't have `spin` installed you can install it with

```bash
curl -fsSL https://developer.fermyon.com/downloads/install.sh | bash
```

Once you have the Spin CLI tool downloaded, we recommend putting the binary into a folder already on your path, eg

```sh
sudo mv spin /usr/local/bin/
```
</details>


<br/>


## Setup
<details><summary>Install Requirements</summary>
<br>

Needed by the `Makefile`
```sh
brew install gettext
cargo install toml-cli
```

[Cargo runner](https://github.com/codeitlikemiley/cargo-runner) Vscode Extension

[spin-install](https://developer.fermyon.com/spin/v2/install)


</details>

- [Spin - Create AKS Cluter](https://goldcoders.notion.site/SPIN-Create-AKS-Cluster-ce360162a47d4152b27830faac57c7a1?pvs=4)
- [Deploying Spin Operator on AKS](https://goldcoders.notion.site/Deploying-Spin-Operator-on-AKS-e17b4c36ef91407fa7c76f207f67aef1?pvs=4)
- [Spin - Deploy using ghcr.io registry](https://goldcoders.notion.site/SPIN-GHCR-IO-Registry-6a08ee81ff17454f8c3fea8e807b4a5c?pvs=4)
- [Spin - Deploy Using Azure Container Registry](https://goldcoders.notion.site/SPIN-Azure-Create-Registry-aa3e271144444c1a99f19828eae0e7ff?pvs=4)
- [Github CI/CD Azure AKS](https://docs.github.com/en/enterprise-cloud@latest/actions/deployment/deploying-to-your-cloud-provider/deploying-to-azure/deploying-to-azure-kubernetes-service)


## App Dev, Build and Deploy
<details> <summary>Development</summary>

<br>

Running
```sh
spin watch
```

will build and run your server as well as recompile your code after making changes.

Using
```sh
spin up
```
will build and serve your app on `127.0.0.1:3000` by default. To serve at a different address, use `spin up --listen <ADDRESS>`.


Feel free to explore the project structure, but the best place to start with your application code is in `src/pages/home.rs`.


Check [leptos](https://github.com/leptos-rs/leptos)  Docs


</details>

<details> <summary>Deploy to Fermyon Cloud</summary>
<br>
To deploy your app to [Fermyon Cloud signup here first][spin-signup]. For more information on [Ferymon Cloud see here][spin-cloud-info].

After you have your Fermyon cloud account and have logged in using `spin login`, running
```sh
spin build
```
will build your application for release. Running

```sh
spin deploy
```
will publish your app to Fermyon cloud.

</details>

<details> <summary>Deploy to AKS</summary>

<br>

> Build App
```sh
spin deploy
# generate kube manifest refering to ghcr.io registry
spin kube scaffold --from ghcr.io/$GH_USER/$PACKAGE_NAME:$VERSION \
    --out spinapp.yaml
# generate kube manifest refering to azure container registry
spin kube scaffold --from $ACR.azurecr.io/$PACKAGE_NAME:$VERSION \
    --out spinapp.yaml
# generate kube manifest refering to ttl.sh registry
spin kube scaffold --from ttl.sh/$GH_USER/$PACKAGE_NAME:$NO_OF_HR \
    --out spinapp.yaml
```

> Push to Registry
```sh
# using ghcr.io registry
spin registry push ghcr.io/$GH_USER/$PACKAGE_NAME:$VERSION
# using azure container registry
spin registry push $ACR.azurecr.io/$PACKAGE_NAME:$VERSION
# using ttl.sh registry 
spin registry push ttl.sh/$GH_USER/$PACKAGE_NAME:$NO_OF_HR
```

> Deploy using Image from Registry
```sh
# deploy using ghcr.io registry
spin kube deploy --from ghcr.io/$GH_USER/$PACKAGE_NAME:$VERSION

# deploy using azure container registry
spin kube deploy --from $ACR.azurecr.io/$PACKAGE_NAME:$VERSION

# deploy using ttl.sh , if you just want to test deployment
spin kube deploy --from ttl.sh/$GH_USER/$PACKAGE_NAME:$NO_OF_HR
```

> Undo Deployment

```sh
kubectl delete -f spinapp.yaml

```



</details>
