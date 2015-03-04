From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv2 0/2] N900 Modem Speech Support
Date: Wed, 4 Mar 2015 20:55:48 +0100
Message-ID: <20150304195548.GA26114@amd>
References: <1425343454-6551-1-git-send-email-sre@kernel.org>
 <20150304192419.GA8981@amd>
 <20150304193650.GA587@fuloong-minipc.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150304193650.GA587@fuloong-minipc.musicnaut.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Sebastian Reichel <sre@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pali Rohar <pali.rohar@gmail.com>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 2015-03-04 21:36:50, Aaro Koskinen wrote:
> On Wed, Mar 04, 2015 at 08:24:19PM +0100, Pavel Machek wrote:
> > @@ -1239,8 +1234,8 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
> >  
> >  		if (copy_to_user((void __user *)arg, &ifver, sizeof(ifver)))
> >  			r = -EFAULT;
> > -		break;
> >  	}
> > +		break;
> >  	case CS_CONFIG_BUFS: {
> >  		struct cs_buffer_config buf_cfg;
> >  
> > @@ -1249,8 +1244,8 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
> >  			r = -EFAULT;
> >  		else
> >  			r = cs_hsi_buf_config(csdata->hi, &buf_cfg);
> > -		break;
> >  	}
> > +		break;
> 
> I think having the break inside the block is more readable.
> Now the indendation is mess.

Half the function does it one way, one the other way. I don't care
which way, but it should be consistent.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
