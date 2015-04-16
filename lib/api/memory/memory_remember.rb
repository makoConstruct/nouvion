require 'sqlite3'

module API
    class MemoryRemember
        def initialize
            @db = SQLite3::Database.new('nouvion.db')

            table = '
                CREATE TABLE IF NOT EXISTS remember (
                    id INTEGER PRIMARY KEY,
                    username TEXT,
                    term TEXT,
                    definition TEXT,
                    relation TEXT
                );
                CREATE INDEX IF NOT EXISTS remember_by_usernamexterm ON remember (username, term);
                CREATE INDEX IF NOT EXISTS remember_by_usernamextermxrelation ON remember (username, term, relation);
                CREATE INDEX IF NOT EXISTS remember_by_definition ON remember (definition);
            '

            @db.execute(table)
        end
        
        def exists(username, term)
            return @db.execute('
                SELECT * FROM remember
                WHERE username = ?
                AND term = ?
            ', [username, term]).length > 0
        end

        def add(username, term, definition, relation)
            @db.execute('
                INSERT INTO remember (username, term, definition, relation)
                VALUES (?, ?, ?, ?)
            ', [username, term, definition, relation])
        end

        def load(term)
            return load_by_term(term)
        end

        def load_by_term(term)
            return @db.execute('
                SELECT * FROM remember
                WHERE term = ?
            ', [term])
        end

        def load_by_definition(definition)
            return @db.execute('
                SELECT * FROM remember
                WHERE definition = ?
            ', [definition])
        end

        def load_similar(term)
            similar_to = term.empty? ? '%' : '%' + term + '%'
            return @db.execute('
                SELECT * FROM remember
                WHERE term LIKE ?
                OR definition LIKE ?
            ', [similar_to, similar_to])            
        end

        def update(username, term, definition, relation)
            @db.execute('
                UPDATE remember
                SET username = ?, term = ?, definition = ?, relation = ?
                WHERE username = ?
                    AND term = ?
            ', [username, term, definition, relation, username, term])
        end
        
        def usernames_for_term(
        
        def delete(term)
            delete_by_term(term)
        end

        def delete_by_term(term)
            @db.execute('
                DELETE FROM remember
                WHERE term = ?
            ', [term])
        end

        def delete_by_definition
            @db.execute('
                DELETE FROM remember
                WHERE definition = ?
            ', [definition])
        end
    end
end
