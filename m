From: Peter Hutterer <peter.hutterer@who-t.net>
Subject: Re: [PATCH] Input: Add MT_TOOL_PALM
Date: Fri, 20 Mar 2015 08:41:55 +1000
Message-ID: <20150319224155.GA32380@jelly.redhat.com>
References: <1426717595-1610-1-git-send-email-charliemooney@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426717595-1610-1-git-send-email-charliemooney@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Charlie Mooney <charliemooney@chromium.org>
Cc: linux-input@vger.kernel.org, Benjamin Tissoires <benjamin.tissoires@gmail.com>, Hans de Goede <hdegoede@redhat.com>, Andrew De Los Reyes <adlr@chromium.org>, Henrik Rydberg <rydberg@bitmath.org>, Jonathan Corbet <corbet@lwn.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Masanari Iida <standby24x7@gmail.com>, Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 18, 2015 at 03:26:35PM -0700, Charlie Mooney wrote:
> Currently there are only two "tools" that can be specified by a
> multi-touch driver: MT_TOOL_FINGER and MT_TOOL_PEN.  In working with
> Elan (The touch vendor) and discussing their next-gen devices it
> seems that it will be useful to have more tools so that their devices
> can give the upper layers of the stack hints as to what is touching
> the sensor.
> 
> In particular they have new experimental firmware that can better
> differentiate between palms vs fingertips and would like to plumb a
> patch so that we can use their hints in higher-level gesture soft-
> ware.  The firmware on the device can reasonably do a better job of
> palm detection because it has access to all of the raw sensor readings
> as opposed to just the width/pressure/etc that are exposed by the
> driver.  As such, the firmware can characterize what a palm looks like
> in much finer-grained detail and this change would allow such a
> device to share its findings with the kernel.
> 
> Signed-off-by: Charlie Mooney <charliemooney@chromium.org>

Acked-by: Peter Hutterer <peter.hutterer@who-t.net>

Cheers,
   Peter

> ---
>  Documentation/input/multi-touch-protocol.txt | 9 ++++++---
>  include/uapi/linux/input.h                   | 3 ++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> index 7b4f59c..b85d000 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -312,9 +312,12 @@ ABS_MT_TOOL_TYPE
>  
>  The type of approaching tool. A lot of kernel drivers cannot distinguish
>  between different tool types, such as a finger or a pen. In such cases, the
> -event should be omitted. The protocol currently supports MT_TOOL_FINGER and
> -MT_TOOL_PEN [2]. For type B devices, this event is handled by input core;
> -drivers should instead use input_mt_report_slot_state().
> +event should be omitted. The protocol currently supports MT_TOOL_FINGER,
> +MT_TOOL_PEN, and MT_TOOL_PALM [2]. For type B devices, this event is handled
> +by input core; drivers should instead use input_mt_report_slot_state().
> +A contact's ABS_MT_TOOL_TYPE may change over time while still touching the
> +device, because the firmware may not be able to determine which tool is being
> +used when it first appears.
>  
>  ABS_MT_BLOB_ID
>  
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index b0a8130..2f62ab2 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -973,7 +973,8 @@ struct input_keymap_entry {
>   */
>  #define MT_TOOL_FINGER		0
>  #define MT_TOOL_PEN		1
> -#define MT_TOOL_MAX		1
> +#define MT_TOOL_PALM		2
> +#define MT_TOOL_MAX		2
>  
>  /*
>   * Values describing the status of a force-feedback effect
> -- 
> 2.1.2
> 
