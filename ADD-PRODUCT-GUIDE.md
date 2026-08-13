# Adding a product to Deck Builder

This is the guide for `add-product-simple.html` — the tool for adding one product (or one pattern) at a time. No setup needed: it's already connected to the live sheet and image library. Just open it and go.

---

## Adding a product

1. **SKU** — type it in, or skip it: if your photo's filename starts with the SKU (e.g. `4231-widget.png`), it fills in automatically once you choose the photo.

2. **Photo & branding shape**
   - **Choose product photo…** — the blank (unbranded) product shot.
   - **Choose mask image…** — a separate file that defines exactly where the logo goes. This needs to already have the branding area cut into its own transparent alpha channel (e.g. authored in Photoshop) — the tool places it to fill the whole photo automatically, no drawing required.
   - Once both are loaded, the photo appears with the mask overlaid in purple. If your mask has more than one separate shape (e.g. two symmetric spots), each one gets its own purple/blue/orange handle set automatically.
   - **Positioning the logo in each spot**: drag the purple center dot to move it, the blue dot to set width/angle, the orange dot to set height/angle. The two don't have to stay at a right angle — dragging them independently lets you rotate and stretch to match the branding area's real shape.
   - **Rotate logo** (90° left/right) — only appears once a mask is loaded. Use this if the logo is landing sideways.

3. **Material** — check **Black product** if the item is solid black (the logo renders flat, no pattern option). Check **Wood product** if the logo should render as a tinted, recessed laser-engraving instead of a normal flat logo.

4. **Product name / tagline** — kept as two separate fields but saved together as `Name: Tagline`, matching how the sheet expects it.

5. **Category** — pick one top-level category, then a subcategory if one applies. Type into the "Add a new…" box for one that doesn't exist yet.

6. **Tags** — comma-separated, used for search.

7. **Description** — aim for under 50 words; the counter turns red past that.

8. **Lead time / setup fee** — default to 5 days / $93.75, both editable.

9. **Price tiers** — tier 2 and tier 3 default to quantities 500 and 1000 (editable). Tier 1 has no default quantity since it varies by product.

10. **Add-ons** — check any that apply (each pre-fills with its usual price, editable per-product). Add a brand-new add-on via the boxes below the list.

11. Click **Submit to sheet** and watch the status line:
    - *"Saved as a new row"* / *"Updated existing row N"* — it worked.
    - A **WARNING** about unmatched columns — a field didn't match anything in the sheet (see Troubleshooting).
    - *"Failed: ..."* — see Troubleshooting.

12. **Confirm it worked**: open the main Deck Builder tool, search for the SKU, and check it renders correctly with a test logo. That's the real proof.

You can revisit a SKU any time — load its photo again, redo anything, submit again — it updates the existing row instead of creating a duplicate.

**Click "Start a new product"** to clear everything and begin the next one — nothing is saved automatically, so submit before starting a new one if you want to keep it.

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
- **"WARNING — these columns don't exist in the sheet and were skipped"** — a field's column name no longer matches an actual header in the `Products` tab (someone likely renamed a header). The rest of the row still saved; check the sheet for the mismatched column name.
- **"Failed: GITHUB_PAT is not configured..."** or **"Failed: GitHub API error 401/403..."** — the backend's GitHub access token is missing or expired. This needs a backend fix, not something fixable from this page — see "For the admin" below.
- **Photo/pattern shows up on GitHub but the deck builder still shows the old one** — uploads try to purge the image CDN's cache automatically, but that can occasionally lag. Give it a few minutes, then hard-refresh (Ctrl+Shift+R) wherever you're checking.
- **Status line says "Row saved, but the live snapshot push failed: ..."** — the sheet row itself saved fine; only the `products.json` refresh that makes it show up live failed, usually a transient GitHub hiccup. It retries automatically every 10 minutes — no action needed unless it's still stale after that.
- **Categories/add-ons show "Couldn't load..." at the top of the form** — the tool couldn't reach the live product data at all. Click **Retry**; if it keeps failing, the backend may be down — see "For the admin."
- **Everything above checks out but nothing happens** — open the browser's DevTools (F12) → Console tab and look for the actual error message; it'll usually point at exactly what failed.

---

## For the admin (technical background, not needed day-to-day)

This tool and the main Deck Builder page both talk to a Cloudflare Worker (`cloudflare-worker.js` in this project, deployed at `deck-builder-api.deckbuilder.workers.dev`), which reads/writes the Google Sheet via the real Sheets API and uploads images/patterns straight to the `deckbuilder-images` GitHub repo. There is no separate Apps Script setup to maintain anymore — the Worker replaced that entirely (see `CLOUDFLARE-MIGRATION-GUIDE.md` for the migration history if useful context). If uploads or submissions start failing with an auth-shaped error, the Worker's secrets (`GOOGLE_SERVICE_ACCOUNT_KEY`, `SPREADSHEET_ID`, `GITHUB_PAT`, `SUBMIT_SECRET`) are what to check first — `wrangler secret put <name>` from this project folder, then `wrangler deploy`.
