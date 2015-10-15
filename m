From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/2] Input: uinput: Sanity check on ff_effects_max and
 EV_FF
Date: Wed, 14 Oct 2015 17:52:26 -0700
Message-ID: <20151015005226.GD3673@dtor-ws>
References: <1442510988-3164-1-git-send-email-elias.vds@gmail.com>
 <1442510988-3164-3-git-send-email-elias.vds@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-input-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442510988-3164-3-git-send-email-elias.vds@gmail.com>
Sender: linux-input-owner@vger.kernel.org
To: Elias Vanderstuyft <elias.vds@gmail.com>
Cc: linux-input@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 17, 2015 at 07:29:48PM +0200, Elias Vanderstuyft wrote:
> Currently the user can specify a non-zero value for ff_effects_max,
> without setting the EV_FF bit.
> Inversely,
> the user can also set ff_effects_max to zero with the EV_FF bit set,
> in this case the uninitialized method ff->upload can be dereferenced,
> resulting in a kernel oops.
> 
> Instead of adding a check in uinput_create_device() and
> omitting setup of ff-core infrastructure silently in case the check fails,
> perform the check early in uinput_setup_device(),
> and print a helpful message and return -EINVAL in case the check fails.
> 
> Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>
> ---
>  drivers/input/misc/uinput.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 345df9b..3a90a16 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -393,6 +393,21 @@ static int uinput_setup_device(struct uinput_device *udev,
>  	if (IS_ERR(user_dev))
>  		return PTR_ERR(user_dev);
>  
> +	if (!!user_dev->ff_effects_max ^ test_bit(EV_FF, dev->evbit)) {
> +		if (user_dev->ff_effects_max)
> +			printk(KERN_DEBUG
> +				"%s: ff_effects_max (%u) should be zero "
> +				"when FF_BIT is not set\n",
> +				UINPUT_NAME, user_dev->ff_effects_max);
> +		else
> +			printk(KERN_DEBUG
> +				"%s: ff_effects_max should be non-zero "
> +				"when FF_BIT is set\n",
> +				UINPUT_NAME);

I do not think this is the right place for this check: userspace is
allowed to write device structure before calling any ioctls to set
various bits. Also, userspace doe snot have to explicitly set EV_FF bit
as input_ff_create() does it for us.

I think the check should be in uinput_create_device() and we should only
check case when udev->ff_effects_max is 0 but EV_FF is set.

Thanks.

-- 
Dmitry
