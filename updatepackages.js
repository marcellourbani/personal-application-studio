const { readFileSync } = require("fs")
const https = require("https")
const hg = u =>
  new Promise((resolve, reject) => {
    https.get(u, {}, res => {
      str = ""
      res.on("data", c => (str += c))
      res.on("end", () => resolve(JSON.parse(str)))
    })
  })
const content = JSON.parse(readFileSync("./package.json").toString())

const { theiaPlugins } = content

async function process() {
  let apiurl
  for (const k in theiaPlugins) {
    if (theiaPlugins[k].match(/^https:\/\/open-vsx.org/)) {
      try {
        apiurl = theiaPlugins[k].replace(/\/[0-9\.]+\/file\/[^\/]+$/, "")
        if (apiurl.match(/^https:\/\/open-vsx.org\/api\/vscode\//))
          apiurl += "/1.50.0"
        const entry = await hg(apiurl)
        console.log(`"${k}":"${entry.files.download}",`)
      } catch (error) {
        console.log(`"${k}":"${theiaPlugins[k]}",`)
      }
    } else {
      console.log(`"${k}":"${theiaPlugins[k]}",`)
    }
  }
}
process()
