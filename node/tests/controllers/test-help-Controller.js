/*jslint node: true , expr:true */
/*global describe, it ,before, after */
"use strict";

var supertest         = require('supertest')   ,    
    expect            = require('chai').expect ,        
    request           = require('request')     ,    
    app               = require('../../server'),    
    Help_Controller   = require('../../controllers/Help_Controller.js');

describe('controllers', function () 
{
    describe('test-help-controller.js', function() 
    {   
        describe('content_cache', function() 
        {
            it('check ctor', function()
            {
                var help_Controller = new Help_Controller();
                expect(Help_Controller).to.be.an("Function");
                expect(help_Controller).to.be.an("Object");            
                expect(help_Controller.content_cache).to.be.an("Object");
                expect(help_Controller.title        ).to.equal(null);
                expect(help_Controller.content      ).to.equal(null);
            }); 
            
            it(' request should add to cache', function()
            {
                var req = { params : { page : 'index.html' }};
                var help_Controller = new Help_Controller(req);
            });
        });
        
        
        it('handle broken images bug', function(done)
        {         
            var gitHub_Path = 'https://raw.githubusercontent.com/TMContent/Lib_Docs/master/_Images/';
            var local_Path  = '/Image/';
            var test_image  = 'signup1.jpg';
            
            var check_For_Redirect = function()
                {                    
                    supertest(app).get(local_Path + test_image)
                                  .expect(302)
                                  .end(function(error, response)
                                        {
                                            expect(response.headers         ).to.be.an('Object');
                                            expect(response.headers.location).to.be.an('String');
                                            expect(response.headers.location).to.equal(gitHub_Path + test_image);
                                            check_That_Image_Exists(response.headers.location);
                                        });
                };
            var check_That_Image_Exists = function(image_Path)
                {                    
                    request.get(image_Path, function(error, response)
                        {
                            expect(response.statusCode).to.equal(200);
                            done();                         
                        });                          
                };
            
            check_For_Redirect();                            
        });
    });
});