From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH v2 20/23] netoops: Add x86 specific bits to packet headers
Date: Tue, 9 Nov 2010 09:22:08 -0500
Message-ID: <20101109142208.GB18269@hmsreliant.think-freely.org>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203334.22479.71661.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101108203334.22479.71661.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 08, 2010 at 12:33:35PM -0800, Mike Waychison wrote:
> We need to be able to gather information about the CPUs that caused the crash.
> 
> This commit only handles x86, but it is desirable to come up with some new
> packet format that can accommodate any architecture.
> 
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> TODO: This should be made more general to other architectures.  As is, we are
> probably okay exporting some value for the 'arch' field.  Different
> architectures though will likely want to gather different data.
> ---
>  drivers/net/netoops.c |   27 +++++++++++++++++++++------
>  1 files changed, 21 insertions(+), 6 deletions(-)
> 
Not sure I see the value in encapsulating arch specific data in a netoops
message.  Ostensibly this information can be inferred at the time of the crash
by the name/ip of the system crashing (one presumes that the sysadmin knows what
systems are what arch, or can look it up easily).

If thats not the case, why not just dump out the contents of /proc/cpuinfo in
ascii form, so that no arch specific data is needed?

Regards
Neil

> diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
> index dc1ee97..f63e12a 100644
> --- a/drivers/net/netoops.c
> +++ b/drivers/net/netoops.c
> @@ -69,16 +69,24 @@ struct netoops_msg {
>  		u32 packet_count;
>  		u32 packet_no;
>  		u32 __reserved1;
> -		u8 __reserved2;
> -		u8 __reserved3;
> -		u8 __reserved4;
> +		u8 x86_family;
> +		u8 x86_model;
> +		u8 x86_stepping;
>  		/*
>  		 * NOTE: fixed length strings for a packet.  NULL
>  		 * termination not required.
>  		 */
>  		char kernel_version[64];
> -		char __reserved5[64];
> -		char __reserved6[64];
> +		char __reserved2[64];
> +		char __reserved3[64];
> +		/* NOTE: regs is 60 or 168 bytes */
> +		struct pt_regs regs; /* arch specific. */
> +		/*
> +		 * NOTE: The header is potentially ~385 bytes
> +		 * already.  That doesn't leave much room for
> +		 * expansion unless we reduce the data size
> +		 * or truncate above fields.
> +		 */
>  	} __attribute__ ((packed)) header;
>  	char data[NETOOPS_DATA_BYTES];
>  } __attribute__ ((packed));
> @@ -94,10 +102,17 @@ static void setup_packet_header(int packet_count, int soft_dump)
>  	msg.header.dump_id = (jiffies/HZ) & 0xffff;
>  	msg.header.packet_count = packet_count;
>  	msg.header.header_size = sizeof(msg.header);
> +#ifndef CONFIG_UML
> +	msg.header.x86_family = current_cpu_data.x86;
> +	msg.header.x86_model = current_cpu_data.x86_model;
> +	msg.header.x86_stepping = current_cpu_data.x86_mask;
> +#endif
>  	strncpy(msg.header.kernel_version,
>  		utsname()->release,
>  		min(sizeof(msg.header.kernel_version),
>  		    sizeof(utsname()->release)));
> +	if (regs != NULL)
> +		memcpy(&msg.header.regs, regs, sizeof(msg.header.regs));
>  }
>  
>  static int packet_count_from_length(unsigned long l)
> @@ -182,7 +197,7 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
>  
>  	/* setup the non varying parts of the message */
>  	memset(&msg, 0, sizeof(msg));
> -	setup_packet_header(packet_count_1 + packet_count_2, soft_dump);
> +	setup_packet_header(packet_count_1 + packet_count_2, regs, soft_dump);
>  
>  	/* Transmission loop */
>  	for (i = 0; i < NETOOPS_RETRANSMIT_COUNT; i++) {
> 
> 
