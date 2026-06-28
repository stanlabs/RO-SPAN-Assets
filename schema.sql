PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS asset_types (
    asset_type_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS locations (
    location_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    location_type TEXT NOT NULL CHECK (location_type IN ('studio', 'storage', 'vehicle', 'field', 'other')),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS productions (
    production_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    episode_code TEXT UNIQUE,
    air_date DATE
);

CREATE TABLE IF NOT EXISTS assets (
    asset_id INTEGER PRIMARY KEY,
    asset_tag TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    asset_type_id INTEGER NOT NULL,
    serial_number TEXT UNIQUE,
    status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'in_use', 'maintenance', 'retired')),
    purchase_date DATE,
    purchase_cost NUMERIC,
    current_location_id INTEGER,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_type_id) REFERENCES asset_types(asset_type_id),
    FOREIGN KEY (current_location_id) REFERENCES locations(location_id)
);

CREATE TABLE IF NOT EXISTS production_asset_assignments (
    assignment_id INTEGER PRIMARY KEY,
    production_id INTEGER NOT NULL,
    asset_id INTEGER NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    released_at DATETIME,
    notes TEXT,
    FOREIGN KEY (production_id) REFERENCES productions(production_id),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);

CREATE TABLE IF NOT EXISTS maintenance_logs (
    maintenance_log_id INTEGER PRIMARY KEY,
    asset_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL,
    vendor TEXT,
    cost NUMERIC,
    details TEXT,
    next_due_date DATE,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);

CREATE INDEX IF NOT EXISTS idx_assets_asset_type_id ON assets(asset_type_id);
CREATE INDEX IF NOT EXISTS idx_assets_location_id ON assets(current_location_id);
CREATE INDEX IF NOT EXISTS idx_assignments_production_id ON production_asset_assignments(production_id);
CREATE INDEX IF NOT EXISTS idx_assignments_asset_id ON production_asset_assignments(asset_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_asset_id ON maintenance_logs(asset_id);
