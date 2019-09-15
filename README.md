# Web-Client Desktop Application based on Ruby on Rails #

### Helpful commands

* kill -9 `cat tmp/pids/server.pid`
search for pid of service using port 3002
* sudo lsof -i tcp:3002 

### What is this repository for? ###

* Desktop Interface for managing Competitions and their Athlets before and during the Competition
* Version 1.0
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### Import von Dateien

Issue: fehlende Titelzeile
darauf achten, dass die erste Zeile auch die Titel enthaelt.
Scheint beim export in cvs ein Problem zu sein. Daher vor reimport die Datei checken

### create a new Database
rake db:migrate RAILS_ENV=development

### Add column to existing model
Mr-Lokalathlet:lokalathlet-web michaelross$ rails g migration add_additionals_to_athlets additionals:json  
      invoke  active_record
      create    db/migrate/20171009121558_add_additionals_to_athlets.rb
Mr-Lokalathlet:lokalathlet-web michaelross$ rake db:migrate
== 20171009121558 AddAdditionalsToAthlets: migrating ==========================
-- add_column(:athlets, :additionals, :json)
   -> 0.0127s
== 20171009121558 AddAdditionalsToAthlets: migrated (0.0130s) =================

Mr-Lokalathlet:lokalathlet-web michaelross$ 



### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact

