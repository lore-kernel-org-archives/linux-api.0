From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH v2 3/8] lib/uuid: introduce few more generic helpers for
 UUID
Date: Tue, 5 Apr 2016 10:48:44 +1000
Message-ID: <20160405104844.3cc45db8@canb.auug.org.au>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1459776610-68469-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20160404164029.9c72a93cb29d619766fbb2d2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404164029.9c72a93cb29d619766fbb2d2-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Mon, 4 Apr 2016 16:40:29 -0700 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Mon,  4 Apr 2016 16:30:05 +0300 Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> > There are new helpers in this patch:
> > 
> > uuid_is_valid		checks if a UUID is valid
> > uuid_be_to_bin		converts from string to binary (big endian)
> > uuid_le_to_bin		converts from string to binary (little endian)
> 	> 
> > They will be used in future, i.e. in the following patches in the series.
> > 
> > This also moves indices arrays to lib/uuid.c to be shared accross modules.
> > 
> > ...
> >
> > --- a/include/linux/uuid.h
> > +++ b/include/linux/uuid.h  
> 
> Nit:
> 
> > +/**
> > +  * uuid_is_valid - checks if UUID string valid
> > +  * @uuid:	UUID string to check
> > +  *
> > +  * Description:
> > +  * It checks if the UUID string is following the format:
> > +  *	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
> > +  * where x is a hex digit.
> > +  *
> > +  * Return: 0 on success, %-EINVAL otherwise.
> > +  */
> > +int uuid_is_valid(const char *uuid)
> > +{
> > +	unsigned int i;
> > +
> > +	if (strnlen(uuid, UUID_STRING_LEN) < UUID_STRING_LEN)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < UUID_STRING_LEN; i++) {
> > +		if (i == 8 || i == 13 || i == 18 || i == 23) {
> > +			if (uuid[i] != '-')
> > +				return -EINVAL;
> > +		} else if (!isxdigit(uuid[i])) {
> > +			return -EINVAL;
> > +		}
> > +	}  
> 
> Could add
> 
> 	if (uuid[i])
> 		return -EINVAL;
> 
> here and lose the additional pass across the input (strlen).

also, why is this not a bool function?

-- 
Cheers,
Stephen Rothwell
