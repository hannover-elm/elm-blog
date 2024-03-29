const fs = require("fs");
const express = require("express");
const app = express();
const port = 3000;

app.use(express.json());

app.post("/api/post", async (req, res) => {
  const post = req.body;
  const id = post.id;
  delete post.id;
  await fs.promises.writeFile(`${__dirname}/posts/${id}.md`, JSON.stringify(post));
  res.json({ ...post, id: id });
});
app.get("/api/post", async (req, res) => {
  const fileNames = await fs.promises.readdir(`${__dirname}/posts`);
  const posts = await Promise.all(fileNames.map(async fileName => {
    if (!fileName.match(/\.md$/)) return false;
    const buffer = await fs.promises.readFile(`${__dirname}/posts/${fileName}`);
    const file = buffer.toString();
    const post = JSON.parse(file);
    post.id = fileName.replace(/\.md$/, "");
    return post;
  }));
  res.json(posts.filter(post => !!post));
});
app.get("/api/post/:id", async (req, res) => {
  const fileName = `${req.params.id}.md`;
  try {
    const buffer = await fs.promises.readFile(`${__dirname}/posts/${fileName}`);
    const file = buffer.toString();
    const post = JSON.parse(file);
    post.id = req.params.id;
    res.json(post);
  } catch(error) {
    res.sendStatus(404);
  }
});

app.get("/elm.js", (req, res) => res.sendFile(`${__dirname}/elm.js`));
app.get("/main.css", (req, res) => res.sendFile(`${__dirname}/main.css`));
app.get(/^/, (req, res) => res.sendFile(`${__dirname}/page.html`));

app.listen(port, () => console.log(`Listening on https://localhost:${port}`));
