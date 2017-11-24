/* global $, Stripe */
$(document).on('turbolinks:load', function(){
    var theForm = $("#pro-form");
    var submitBtn = $("#form-signup-btn");
    
    // set Stripe publice key
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    
    submitBtn.click(function(event){
        event.preventDefault()
        submitBtn.val("Processing").prop('disabled', true);
        
        // collect credit card fields
        var ccNum = $('#card_number').val(),
            cvcNum = $('#card_code').val(),
            expMonth = $('#card_month').val(),
            expYear = $('#card_year').val();
            
        // validate card fields
        var error = false;
        
        if (!Stripe.card.validateCardNumber(ccNum)) {
            error = true;
            alert("The credit card number appears to be invalid");
        }
        
        // validate cvc number
        if (!Stripe.card.validateExpiry(ccNum)) {
            error = true;
            alert("The CVC number appears to be invalid");
        }
        
        // validate expiration date
        if (!Stripe.card.validateCardNumber(ccNum)) {
            error = true;
            alert("The credit card expiration date appears to be invalid");
        }
        
        if (error) {
            submitBtn.prop('disabled', false).val("Sign Up");
        } else {
            // send card info to Stripe
            Stripe.createToken({
                number: ccNum,
                cvc: cvcNum,
                exp_month: expMonth,
                exp_year: expYear
            }, stripeResponseHandler);
        }
        return false;
    });
    
    // Stripe returns token
    function stripeResponseHandler(status, response) {
        var token = response.id;
        
        // inject card token in hidden field
        theForm.append($('<input type="hidden" name="user[stripe_card_token]">').val(token));
        
        // submit form
        theForm.get(0).submit();
    }
});