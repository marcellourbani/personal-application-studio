# Personal application studio

This is a customized [Theia](https://theia-ide.org/) distribution targeted at SAP developers inspired by [SAP Business Application Studio](https://www.sapstore.com/solutions/45318/SAP-Business-Application-Studio)

It's a hobby project, so it only includes freely distributable software and has several limitations compared to BAS, as it's not integrated in any cloud environment, doesn't include several SAP specific extensions like workflow editors and UI5 grafical editor
Sadly this includes the [CAP CDS extension](https://marketplace.visualstudio.com/items?itemName=SAPSE.vscode-cds), available on vscode market but not on openvsx.

## Features

- ABAP language support - including ABAPLint
- UI5 language support
- Template wizard

## Installation

Runs in a docker container, you don't need to download anything manually other than docker. Once you installed docker,you can run it like this:

```bash
docker run --name theia_pas -d -v ${HOME}/pasworkspace:/home/user/projects -p 3000:3000 murbani/personal-application-studio
```

and then your environment will be at [http://localhost:3000](http://localhost:3000)

The volume bit:

> -v ${HOME}/pasworkspace:/home/user/projects

is optional, will allow you to keep your code out of the container, which you might want to delete and recreate liberally

If you have a set of extensions you want to include by default you can put the vsix files ina folder, say **pasplugins** and mount it:

```bash
docker run --name theia_pas -d -v ${HOME}/pasworkspace:/home/user/projects -v ${HOME}/pasplugins:/home/user/default-plugins -p 3000:3000 murbani/personal-application-studio
```

## Running the template wizard

Go to the command palette (usually ctrl+shift+p)
run command "Open template wizard"

## managing the container

```bash
# stop the container
docker stop theia_pas

# start it
docker start theia_pas

# delete it
docker rm theia_pas

# delete the image
docker image rm murbani/personal-application-studio

```

## License

These scripts are provided under the [MIT license](LICENSE)
Theia is distributed under the eclipse or Gnu GPL v2
