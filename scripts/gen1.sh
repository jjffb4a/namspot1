# increment-v1-basic-css.sh — loverk 20.05.2025

mkdir -p app/styles && cat > app/styles/app.css <<'EOF'
/* app/styles/app.css loverk 20.05.2025 */
body {
  font-family: system-ui, sans-serif;
  margin: 2rem;
  background: #fdfdfd;
  color: #111;
}
label {
  font-weight: bold;
}
input {
  padding: 0.4rem;
  margin-top: 0.5rem;
  display: block;
  width: 100%;
  max-width: 300px;
  border: 1px solid #ccc;
}
ul {
  margin-top: 1rem;
  list-style: none;
  padding: 0;
}
li {
  padding: 0.25rem;
  background: #eef;
  margin-bottom: 0.2rem;
}
mark {
  background: yellow;
}
EOF

git add .
git commit -m "v1: 💄 Basic CSS enhancements"
git push
