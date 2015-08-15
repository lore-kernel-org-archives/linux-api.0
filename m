From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Documentation: iio-trig-sysfs: Add missing ABI
Date: Sat, 15 Aug 2015 16:09:12 +0100
Message-ID: <55CF5618.7040808@kernel.org>
References: <cover.1439378363.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1439378363.git.cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/08/15 12:26, Cristina Opriceana wrote:
> Add the ABI documentation for the add_trigger and remove_trigger
> attributes, found in iio-trig-sysfs.
> 
> Cristina Opriceana (2):
>   Documentation: iio-trig-sysfs: Document add_trigger attribute
>   Documentation: iio-trig-sysfs: Add remove_trigger attribute ABI
> 
>  .../ABI/testing/sysfs-bus-iio-trigger-sysfs        | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
These two could easily have been one patch given their paired nature,
but I don't care that much.

Applied to the togreg branch of iio.git (fuzz due to a pervious patch in there)

Thanks,

Jonathan
