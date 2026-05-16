# Website Publishing Dashboard

Live site: https://josuetrujo.github.io

## Publish Website

```meta-bind-button
style: primary
label: Publish Website
icon: upload-cloud
actions:
  - type: command
    command: obsidian-shellcommands:shell-command-REPLACE_WITH_SHELL_COMMAND_ID
```

Shell Commands is not currently installed in this vault. To finish the one-click button:

1. Install and enable the Obsidian community plugin named **Shell Commands**.
2. Create a Shell Commands command named **Publish Website**.
3. Set the command to run:

```shell
/Users/josuetrujo/Documents/Websites/josuetrujo-site/scripts/publish-from-obsidian.sh
```

4. In that command's Shell Commands settings, copy the Shell command id.
5. Replace `REPLACE_WITH_SHELL_COMMAND_ID` in the Meta Bind button above with that id.

The final command line should look like:

```yaml
command: obsidian-shellcommands:shell-command-YOUR_SHELL_COMMAND_ID
```

## Workflow

1. Create or edit files in `Website/`.
2. Put them in the correct subfolder.
3. Press the Publish Website button.
4. GitHub Pages deploys the updated site.

## Public Boundary

Only `Website/` is public-facing for this workflow. Nothing outside `Website/` is copied into the Quartz content folder by the publishing script.

## Public Folder Structure

```text
Website/
|-- index.md
|-- about.md
|-- blog.md
|-- projects.md
|-- blog/
|-- portfolio/
|-- ai-consulting/
|-- marketing-agency/
|-- sales-consulting/
|-- graphic-design/
|-- video-production/
|-- follow-up-app/
|-- ai-legal-library/
|-- assets/
`-- Website Publishing Dashboard.md
```

## Intended Uses

- Blog posts live in `Website/blog/`.
- Portfolio case studies live in `Website/portfolio/`.
- Business, service, and venture sites live in folders such as `Website/ai-consulting/`, `Website/follow-up-app/`, and the other service folders.

## Standalone HTML Site Conventions

Each public business site can use an `index.html` file. Supporting CSS, JavaScript, images, PDFs, and other assets can live alongside that HTML file or in `Website/assets/`.

Example public URL:

```text
https://josuetrujo.github.io/ai-consulting/
```
