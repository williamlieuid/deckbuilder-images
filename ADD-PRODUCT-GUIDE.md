# Adding a product to Deck Builder

This is the guide for `add-product-simple.html` — the tool for adding one product (or one pattern) at a time. No setup needed: it's already connected to the live sheet and image library. Just open it and go.

---

## Adding a product

1. **Product Number, Product Name, and Color** — sit side by side at the top. The Product Number is exactly 4 digits (anything else is stripped automatically as you type). Color is optional — only fill it in if this exact photo is one of several color options for the same product. Fill these in first — your uploaded files below get renamed to match automatically, so they're easy to find later.

2. **Product Photo & Logo Placement**
   - **Choose Blank Product Image** — a plain photo of the product with no logo or branding on it.
   - **Choose Mask Image** — a separate file the same size as the photo, with the branding area masked out in any solid color in an image editor — everything else in the file left transparent. The tool places it over the whole photo automatically, no drawing required.
   - Once both are loaded, the photo appears with the mask overlaid in purple. If that file has more than one separate shape (e.g. two symmetric spots), each one gets its own purple/blue/orange handle set automatically.
   - **Positioning the logo in each spot**: the **purple dot** marks where the logo will be — drag it to move the whole thing. The **blue dot** pulls towards the right extent of the branding area; the **orange dot** pulls towards the bottom extent. The two don't have to stay at a right angle — dragging them independently lets you rotate and stretch to match the branding area's real shape.
   - **Rotate logo** (90° left/right) — only appears once a mask image is loaded. Use this if the logo is landing sideways.

3. **Material** — leave unchecked for a normal full-color logo. **Black Leather Product**: logo shows as a flat, solid color. **Wood Product**: logo shows as if engraved into the wood. **Clear / Acrylic Product**: logo shows as a light grey etched look, like laser-etching on clear acrylic (e.g. ClearCharge).

4. **Subtitle** (required) — a secondary line shown under the product name, e.g. "(white)" or a fuller description of the specific variant.

5. **Category** — pick one top-level category, then a subcategory if one applies. Type into the "Add a new…" box for one that doesn't exist yet.

6. **Search Tags** — comma-separated, used for search.

7. **Description** — aim for under 50 words; the counter turns red past that.

8. **Production Time / Setup Fee** — default to 5 days / $93.75, both editable.

9. **Price tiers** — Tier 1's quantity is a simple choice between **1** and **100** (whichever applies to this product — only one can be picked). Tier 2 and Tier 3 default to quantities 500 and 1000 (both editable).

10. **Add-ons** — check any that apply (each pre-fills with its usual price, editable per-product). Add a brand-new add-on via the boxes below the list.

11. Click **Add Product** (this button reads **Update Product** instead when you got here via the Edit a Product tab). A green **✓ Product added!** (or **✓ Product updated!**) message confirms it worked and the form clears itself, ready for the next one. A red message means something needs attention — see Troubleshooting.

12. **Confirm it worked**: open the main Deck Builder tool, search for the product number, and check it renders correctly with a test logo. That's the real proof.

Nothing is saved until you click that button — there's no separate "start over" step needed, since a successful save already clears the form for you.

---

## Editing an existing product

Switch to the **Edit a Product** tab and search by product number or name — pick it from the suggestions that appear. Everything about it (photo, logo placement, category, pricing, add-ons, material) loads into the Add a Product tab, ready to change, and the button there switches to **Update Product**. Make your edits and click it — since the product number already exists, it updates that product instead of creating a duplicate. If you didn't touch the photo or mask image, they're left exactly as they were (no wasted re-upload).

One limitation: this simplified tool can only show/edit a product whose logo area was set up as a single uploaded mask file (the normal case for anything added through this tool). A product whose branding was drawn with the full masking tool (rectangles/polygons) can still have its other details — name, price, category, etc. — edited here, but its logo placement itself needs the full masking tool.

---

## Adding, viewing, or removing a pattern

Switch to the **Add a Pattern** tab. Patterns aren't tied to any product — they're a shared library every pattern-eligible product can use.

- **To add one**: click **Upload new pattern…** and pick the image file. It's live on the site within a minute.
- **Existing Patterns** (below the upload button) shows every pattern currently in the library as a thumbnail.
- **To remove one**: click the small ✕ on its thumbnail. You'll be asked to confirm first — **this can't be undone**, and any product currently branded with that exact pattern will lose it, so only remove one you're sure is no longer in use.

A pattern that tiles edge-to-edge with no baked-in white border looks cleanest — the app auto-trims a little margin on selection, but a genuinely seamless file needs no correction at all.

---

## Troubleshooting

- **"Unauthorized"** — shouldn't happen in normal use (the tool already carries the right credentials). If you see it, the backend's shared secret may have changed — contact whoever manages the Deck Builder backend.
- **"...something needs attention: these fields didn't match the sheet and were skipped"** — a field's column name no longer matches an actual header in the `Products` tab (someone likely renamed a header). The rest of the row still saved; check the sheet for the mismatched column name.
- **"Something went wrong: GITHUB_PAT is not configured..."** or **"...GitHub API error 401/403..."** — the backend's GitHub access token is missing or expired. This needs a backend fix, not something fixable from this page — see "For the admin" below.
- **Photo/pattern shows up on GitHub but the deck builder still shows the old one** — uploads try to purge the image CDN's cache automatically, but that can occasionally lag. Give it a few minutes, then hard-refresh (Ctrl+Shift+R) wherever you're checking.
- **Status line says "Row saved, but the live snapshot push failed: ..."** — the sheet row itself saved fine; only the `products.json` refresh that makes it show up live failed, usually a transient GitHub hiccup. It retries automatically every 10 minutes — no action needed unless it's still stale after that.
- **Categories/add-ons show "Couldn't load..." at the top of the form** — the tool couldn't reach the live product data at all. Click **Retry**; if it keeps failing, the backend may be down — see "For the admin."
- **Everything above checks out but nothing happens** — open the browser's DevTools (F12) → Console tab and look for the actual error message; it'll usually point at exactly what failed.

---

## For the admin (technical background, not needed day-to-day)

This tool and the main Deck Builder page both talk to a Cloudflare Worker (`cloudflare-worker.js` in this project, deployed at `deck-builder-api.deckbuilder.workers.dev`), which reads/writes the Google Sheet via the real Sheets API and uploads images/patterns straight to the `deckbuilder-images` GitHub repo. There is no separate Apps Script setup to maintain anymore — the Worker replaced that entirely (see `CLOUDFLARE-MIGRATION-GUIDE.md` for the migration history if useful context). If uploads or submissions start failing with an auth-shaped error, the Worker's secrets (`GOOGLE_SERVICE_ACCOUNT_KEY`, `SPREADSHEET_ID`, `GITHUB_PAT`, `SUBMIT_SECRET`) are what to check first — `wrangler secret put <name>` from this project folder, then `wrangler deploy`.
