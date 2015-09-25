From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v6 03/14] power: bq24257: Streamline input current limit
 setup
Date: Fri, 25 Sep 2015 08:52:52 -0500
Message-ID: <20150925135251.GA9370@borg>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
 <1443151618-29742-4-git-send-email-dannenberg@ti.com>
 <20150925132302.GD15509@lpalcu-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150925132302.GD15509@lpalcu-desk>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 25, 2015 at 04:23:03PM +0300, Laurentiu Palcu wrote:
> On Thu, Sep 24, 2015 at 10:26:47PM -0500, Andreas Dannenberg wrote:
> [...]
> > -	if (reset_iilimit) {
> > +		/* reset input current limit */
> >  		ret = bq24257_field_write(bq, F_IILIMIT, IILIMIT_500);
> >  		if (ret < 0)
> >  			goto error;
> > -	} else if (config_iilimit) {
> > -		schedule_delayed_work(&bq->iilimit_setup_work,
> > +	} else if (!old_state.power_good) {
> > +		dev_dbg(bq->dev, "Power inserted\n");
> > +		if (bq->iilimit_autoset_enable)
> iilimit_autoset_enable is introduced in patch 6. If we ever need to
> bisect this code, this patch will fail to build.

Good catch!! I want to fix this and retest/resubmit (and put in the
suggestion from your other email too). I know it's a lot of traffic but
it should be done right :)

Regards,
Andreas
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
