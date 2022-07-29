var express = require("express");
var app = express();
app.use(express.static("public"));
app.set("view engine", "ejs");
app.set("views", "./views");
app.listen(3001);
var bodyParser = require('body-parser');

var urlencodedParser = bodyParser.urlencoded({ extended: false })
var pg = require('pg');
var config = {
    user: 'postgres',
    database: 'final_project',
    password: '30112002',
    host: 'localhost',
    port: 3011,
    max: 10,
    idleTimeoutMillis: 30000,
};
var pool = new pg.Pool(config);
pool.connect;
// Static Files
app.use(express.static('assets'));
app.use('/css', express.static(__dirname + 'assets/css'));

app.get("/Manage/client.html", function (req, res) {

    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        client.query('SELECT *FROM customer', function (err, result) {
            done();
            if (err) {
                return console.error('error', err);
            }
            res.render("list.ejs", { danhsach: result });
        });
    });
});

app.get("/Manage/client.html/customer_insert", function (req, res) {

    res.render("data_insert.ejs");

});

app.post("/Manage/client.html/customer_insert", urlencodedParser, function (req, res) {

    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        var customerid = req.body.txtCustomer_id;
        var customername = req.body.txtCustomer_name;
        var email = req.body.txtemail;
        var birth = req.body.txtbirthday;

        client.query("INSERT INTO public.customer(customer_id, customer_name, email, date_of_birth) VALUES ('" + customerid + "', '" + customername + "', '" + email + "','" + birth + "')", function (err, result) {
            // call done() to release the client back to the
            done();
            if (err) {
                return console.error('error', err);
            }
            res.redirect("/Manage/client.html");
        });
    });

});


//show form
app.get("/set_the_table.html", function (req, res) {
    pool.connect(function (err, client, done) {
            
        if (err) {
            return console.error('error fetching client from pool', err);
        }
        client.query('SELECT *FROM menu order by meal_id', function (err, result) {
            done();
            if (err) {
                return console.error('error', err);
            }
            res.render("goi_mon.ejs", { danhsach1: result });
        });
    });

    //res.render("goi_mon.ejs");

});



//Insert 
app.post("/set_the_table.html", urlencodedParser, function (req, res) {

    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        var ban = req.body.txtTable_id;
        var khach = req.body.txtCustomer_id;
        var mon = req.body.txtMeal_id;
        var sl = req.body.txtCount;
        var time = req.body.txtDate;
        client.query("INSERT INTO public.order_and_payment(table_id, customer_id, meal_id, counts, date_time) VALUES ('" + ban + "', '" + khach + "', '" + mon + "', '" + sl + "', '" + time + "')", function (err, result) {
            // call done() to release the client back to the
            done();
            if (err) {
                return console.error('error', err);
            }
            res.redirect("/");
        });
    });

});



app.get("/menu.html", function (req, res) {
    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        client.query('SELECT *FROM menu order by meal_id', function (err, result) {
            done();
            if (err) {
                return console.error('error', err);
            }
            res.render("menu.ejs", { danhsach1: result });
        });
    });
});

app.get("/menu.html/menu_insert", function (req, res) {

    res.render("menu_insert.ejs");

});

app.post("/menu.html/menu_insert", urlencodedParser, function (req, res) {

    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        var mealid = req.body.txtmeal_id;
        var mealname = req.body.txtmeal_name;
        var price = req.body.txtprice;

        client.query("INSERT INTO public.menu(meal_id, meal_name, price) VALUES ('" + mealid + "', '" + mealname + "', '" + price + "')", function (err, result) {
            // call done() to release the client back to the
            done();
            if (err) {
                return console.error('error', err);
            }
            res.redirect("/menu.html");
        });
    });

});
app.get("/menu.html/menu_delete/:id", function (req, res) {
    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        var id = req.params.id;
        client.query("DELETE FROM public.menu WHERE meal_id= '" + id + "' ", function (err, result) {
            // call done() to release the client back to the
            done();
            if (err) {
                return console.error('error', err);
            }
            res.redirect("/menu.html");
        });
    });

});
//show form

app.get("/pay.html", function (req, res) {
    res.render("paymen.ejs");
});


app.post("/pay.html", urlencodedParser, function (req, res) {

    var khach = req.body.txtCustomer_id;
    var time = req.body.txtDate;
    var VALUES1

    pool.query('SELECT *FROM order_and_payment', function (err, result) {

        if (err) {
            return console.error('error', err);
        }
        VALUES1 = result;
        // console.log(VALUES1);
    });


    pool.query("select sum(total_price) as bill from public.payment where customer_id= '" + khach + "' and date_time='" + time + "'", function (err, result) {
        // call done() to release the client back to the

        if (err) {
            return console.error('error', err);
        }
        res.render("payment2.ejs", { danhsach3: result, danhsach4: VALUES1 });
    });


});




app.get("/pay.html/:customer_id", function (req, res) {
    pool.connect(function (err, client, done) {

        if (err) {
            return console.error('error fetching client from pool', err);
        }
        var id = req.params.customer_id;
        client.query("DELETE FROM public.order_and_payment WHERE customer_id= '" + id + "' ", function (err, result) {
            // call done() to release the client back to the
            done();
            if (err) {
                return console.error('error', err);
            }
            res.redirect("/pay.html");
        });
    });

});


//show form
app.get("/set_table.html", function (req, res) {

    res.render("dat_ban.ejs");

});



//Insert 
app.post("/set_table.html", urlencodedParser, function (req, res) {

    pool.connect(function (err, client, done) {


        var ban = req.body.txtTable_id;
        var khach = req.body.txtCustomer_id;
        var note = req.body.txtNote;
        var time = req.body.txtAppointment_date;

        client.query('SELECT *FROM set_table', function (err, result) {
            done();
            if (err) {
                return console.error('error', err);
            }
            res.render("test.ejs", { danhsach5: result });
        });


        client.query("INSERT INTO public.set_table(table_id, customer_id, appointment_date, note) VALUES ('" + ban + "', '" + khach + "', '" + time + "', '" + note + "')", function (err, result) {
            // call done() to release the client back to the
            done();
            if (err) {
                return console.error('error', err);
            }
            //res.redirect("/");
        });
    });
});

app.get("/", function (req, res) {
    res.render("data");
});