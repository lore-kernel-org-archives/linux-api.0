From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2 2/2] Input: uinput: Sanity check on ff_effects_max and
 EV_FF
Date: Fri, 18 Dec 2015 17:50:38 -0800
Message-ID: <20151219015038.GD26333@dtor-ws>
References: <1442510988-3164-3-git-send-email-elias.vds@gmail.com>
 <1447004254-12431-1-git-send-email-elias.vds@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447004254-12431-1-git-send-email-elias.vds@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Elias Vanderstuyft <elias.vds@gmail.com>
Cc: linux-input@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 08, 2015 at 06:37:34PM +0100, Elias Vanderstuyft wrote:
> Currently the user can set ff_effects_max to zero with the EV_FF bit
> (and the FF_GAIN and/or FF_AUTOCENTER bits) set,
> in this case the uninitialized methods
> ff->set_gain and/or ff->set_autocenter can be dereferenced,
> resulting in a kernel oops.
> 
> Check in uinput_create_device() and
> print a helpful message and return -EINVAL in case the check fails.
> 
> Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>

Applied, thank you.

> ---
> Changes in v2:
>   - Rebase on pending patches from David Herrmann and Benjamin Tissoires:
>     - v3 Input: uinput - add new UINPUT_DEV_SETUP and UI_ABS_SETUP ioctl
>     - Input: uinput - rework ABS validation
>   - Don't require EV_FF bit to be set when ff_effects_max is non-zero
>   - Move check from uinput_setup_device() to uinput_create_device()
>   - Update commit description
> 
> At the same time, the new UINPUT_DEV_SETUP and UI_ABS_SETUP ioctls were
> tested as well (in both orders).
> The legacy write() (instead of UINPUT_DEV_SETUP) was also tested.
> 
>  drivers/input/misc/uinput.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 1d93037..b9d0713 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -272,6 +272,13 @@ static int uinput_create_device(struct uinput_device *udev)
>  		input_set_events_per_packet(dev, 60);
>  	}
>  
> +	if (test_bit(EV_FF, dev->evbit) && !udev->ff_effects_max) {
> +		printk(KERN_DEBUG "%s: ff_effects_max should be non-zero when FF_BIT is set\n",
> +			UINPUT_NAME);
> +		error = -EINVAL;
> +		goto fail1;
> +	}
> +
>  	if (udev->ff_effects_max) {
>  		error = input_ff_create(dev, udev->ff_effects_max);
>  		if (error)
> -- 
> 1.9.3
> 

-- 
Dmitry
