
-- Create postgres and admin roles

create user postgres with password "w5V2NGcFWYpn";
grant rds_superuser to postgres;

create user admin with password "w5V2NGcFWYpn";
grant rds_superuser to admin;
