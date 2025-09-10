require('dotenv').config();
const express = require('express');

const app = express();

// Parse JSON request bodies
app.use(express.json());

// In-memory data store (for demo purposes)
let items = [];
let nextId = 1;

// Health check / root
app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Backend is running' });
});

// GET /items - list all items
app.get('/items', (req, res) => {
  res.json({ data: items });
});

// GET /items/:id - fetch a single item
app.get('/items/:id', (req, res) => {
  const id = Number(req.params.id);
  const item = items.find((i) => i.id === id);
  if (!item) {
    return res.status(404).json({ error: 'Item not found' });
  }
  res.json({ data: item });
});

// POST /items - create a new item
app.post('/items', (req, res) => {
  const { name, description } = req.body || {};

  if (typeof name !== 'string' || name.trim() === '') {
    return res.status(400).json({ error: 'Field "name" is required' });
  }

  const newItem = {
    id: nextId++,
    name: name.trim(),
    description: typeof description === 'string' ? description.trim() : null,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  items.push(newItem);
  res.status(201).json({ data: newItem });
});

// PATCH /items/:id - partially update an item
app.patch('/items/:id', (req, res) => {
  const id = Number(req.params.id);
  const itemIndex = items.findIndex((i) => i.id === id);
  if (itemIndex === -1) {
    return res.status(404).json({ error: 'Item not found' });
  }

  const { name, description } = req.body || {};
  const existing = items[itemIndex];

  if (name !== undefined) {
    if (typeof name !== 'string' || name.trim() === '') {
      return res.status(400).json({ error: 'Field "name" must be a non-empty string' });
    }
    existing.name = name.trim();
  }

  if (description !== undefined) {
    if (description !== null && typeof description !== 'string') {
      return res.status(400).json({ error: 'Field "description" must be a string or null' });
    }
    existing.description = typeof description === 'string' ? description.trim() : null;
  }

  existing.updatedAt = new Date().toISOString();
  items[itemIndex] = existing;
  res.json({ data: existing });
});

// DELETE /items/:id - delete an item
app.delete('/items/:id', (req, res) => {
  const id = Number(req.params.id);
  const itemIndex = items.findIndex((i) => i.id === id);
  if (itemIndex === -1) {
    return res.status(404).json({ error: 'Item not found' });
  }

  items.splice(itemIndex, 1);
  res.status(204).send();
});

// Not found handler
app.use((req, res, next) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handler
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  // In production, avoid leaking stack traces. Keep this simple.
  console.error(err); // eslint-disable-line no-console
  res.status(500).json({ error: 'Internal Server Error' });
});

const port = Number(process.env.PORT) || 3000;
app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`); // eslint-disable-line no-console
});

module.exports = { app };


