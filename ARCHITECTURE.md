## Rake tasks

Gdy (?) jest w komentarzu, to nie ma tego jeszcze:

```bash
bundle exec rake install # Instalacja (?)
bundle exec rake doctor # Diagnoza czemu nie działa (?)
bundle exec rake console # Konsola
bundle exec rake runner TASK=general/check_health # Sprawdza przeglądarkę
bundle exec rake generate:model NAME=User # Generuje model z migracją
bundle exec rake generate:task NAME=dupa/jasio_pierdzi_stasio # Generuje nowego taska
bundle exec rake db:create # Tworzy bazę danych
bundle exec rake db:drop # Dropuje bazę danych
bundle exec rake db:new_migration NAME=foo_bar_migration # Tworzy migrację bazy danych
bundle exec rake db:migrate # Migruje bazę danych
bundle exec rake db:rollback # Cofa o jedną migrację
bundle exec rake db:seed # Uruchamia db/seeds.rb więc inicjuje bazę danych
```