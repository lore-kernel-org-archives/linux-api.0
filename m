From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH]: Mux n_gsm: Add a DLCI hangup state and callback
Date: Mon, 29 Jun 2015 18:06:28 +0200
Message-ID: <DF593B22-45A6-40F2-B8AA-7EAFC55CC9F9@holtmann.org>
References: <1435593236.25711.3.camel@tldlab125>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435593236.25711.3.camel@tldlab125>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?Gwenn_Bourr=C3=A9e?= <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, inux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Gwenn,

> Please review the following patch:
> 
> From 6e006bd522124d0e8a2f6075099a21f7051a426f Mon Sep 17 00:00:00 2001
> From: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Mon, 29 Jun 2015 17:26:01 +0200
> Subject: [PATCH] Mux n_gsm: Add a DLCI hangup state and callback

this is borked. Consider using git format-patch and git send-email.

> 
> Use of asynchronous hangup instead of vhangup.

In general it is useful to have a bit more explanation in your patch on what it does, why it does it and how.

> 
> Signed-off-by: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

You do not need to have yourself twice here.

> Signed-off-by: Mustapha Ben Zoubeir <mustaphax.ben.zoubeir-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nicolas LOUIS <nicolasx.louis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ravindran, Arun <arun.ravindran-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Please make sure reviewed-by are correct. I would use first name last name <email>. And make sure to close the email with >

> 
> ---
> drivers/tty/n_gsm.c | 27 +++++++++++++++++++++++++--
> 1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index d6e0ea0..762f555 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -135,6 +135,7 @@ struct gsm_dlci {
> #define DLCI_OPENING		1	/* Sending SABM not seen UA */
> #define DLCI_OPEN		2	/* SABM/UA complete */
> #define DLCI_CLOSING		3	/* Sending DISC not seen UA/DM */
> +#define DLCI_HANGUP		4	/*HANGUP received  */

Please follow coding style. The example of the comment is above.

> 	struct mutex mutex;
> 
> 	/* Link layer */
> @@ -1530,7 +1531,8 @@ static void gsm_dlci_begin_open(struct gsm_dlci
> *dlci)
> static void gsm_dlci_begin_close(struct gsm_dlci *dlci)
> {
> 	struct gsm_mux *gsm = dlci->gsm;
> -	if (dlci->state == DLCI_CLOSED || dlci->state == DLCI_CLOSING)
> +	if (dlci->state == DLCI_CLOSED || dlci->state == DLCI_CLOSING ||
> +		dlci->state == DLCI_HANGUP)

I am pretty sure this indentation is wrong. You can not tell the actual code block apart from the condition. So either align with the dlci->state above or use two tabs. Check what coding style is common in this code and choose the one used in similar multiline if conditions.

> 		return;
> 	dlci->retries = gsm->n2;
> 	dlci->state = DLCI_CLOSING;
> @@ -1717,7 +1719,7 @@ static void gsm_dlci_release(struct gsm_dlci
> *dlci)
> 		gsm_destroy_network(dlci);
> 		mutex_unlock(&dlci->mutex);
> 
> -		tty_vhangup(tty);
> +		tty_hangup(tty);
> 
> 		tty_port_tty_set(&dlci->port, NULL);
> 		tty_kref_put(tty);
> @@ -2339,6 +2341,26 @@ static void gsmld_flush_buffer(struct tty_struct
> *tty)
> }
> 
> /**
> + *	gsmld_hangup		-	hangup the ldisc for this tty
> + *	@tty: device
> + */
> +
> +static int gsmld_hangup(struct tty_struct *tty)
> +{
> +	struct gsm_mux *gsm = tty->disc_data;
> +	int i;
> +	struct gsm_dlci *dlci;
> +
> +	for (i = NUM_DLCI-1; i >= 0; i--) {
> +		dlci = gsm->dlci[i];

I would have moved the struct gsm_dlci declaration into the body of the for loop.

> +		if (dlci)
> +			dlci->state = DLCI_HANGUP;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>  *	gsmld_close		-	close the ldisc for this tty
>  *	@tty: device
>  *
> @@ -2836,6 +2858,7 @@ static struct tty_ldisc_ops tty_ldisc_packet = {
> 	.name            = "n_gsm",
> 	.open            = gsmld_open,
> 	.close           = gsmld_close,
> +	.hangup          = gsmld_hangup,
> 	.flush_buffer    = gsmld_flush_buffer,
> 	.chars_in_buffer = gsmld_chars_in_buffer,
> 	.read            = gsmld_read,

Regards

Marcel
