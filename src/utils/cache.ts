/**
 * Cache Utility
 * Redis caching utility for the application
 */

interface CacheOptions {
  ttl?: number; // Time to live in seconds
}

class CacheService {
  private cache: Map<string, { data: any; expiry: number }>;
  private defaultTTL: number = 3600; // 1 hour default

  constructor() {
    this.cache = new Map();
  }

  /**
   * Get value from cache
   */
  async get<T>(key: string): Promise<T | null> {
    const cached = this.cache.get(key);
    
    if (!cached) {
      return null;
    }

    // Check if expired
    if (Date.now() > cached.expiry) {
      this.cache.delete(key);
      return null;
    }

    return cached.data as T;
  }

  /**
   * Set value in cache
   */
  async set<T>(key: string, value: T, options?: CacheOptions): Promise<void> {
    const ttl = options?.ttl || this.defaultTTL;
    const expiry = Date.now() + (ttl * 1000);

    this.cache.set(key, {
      data: value,
      expiry,
    });
  }

  /**
   * Delete value from cache
   */
  async del(key: string): Promise<void> {
    this.cache.delete(key);
  }

  /**
   * Delete all keys matching pattern
   */
  async delPattern(pattern: string): Promise<void> {
    const regex = new RegExp(pattern.replace('*', '.*'));
    const keysToDelete: string[] = [];

    for (const key of this.cache.keys()) {
      if (regex.test(key)) {
        keysToDelete.push(key);
      }
    }

    keysToDelete.forEach(key => this.cache.delete(key));
  }

  /**
   * Check if key exists
   */
  async exists(key: string): Promise<boolean> {
    const cached = this.cache.get(key);
    
    if (!cached) {
      return false;
    }

    // Check if expired
    if (Date.now() > cached.expiry) {
      this.cache.delete(key);
      return false;
    }

    return true;
  }

  /**
   * Clear all cache
   */
  async clear(): Promise<void> {
    this.cache.clear();
  }
}

// Export singleton instance
export const cacheService = new CacheService();
