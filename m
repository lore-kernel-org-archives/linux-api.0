From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] pkey.7: New page with overview of Memory Protection
 Keys
Date: Mon, 17 Oct 2016 15:06:00 -0700
Message-ID: <58054B48.1030600@intel.com>
References: <20160913194406.20CBFD0C@ray> <20160913194438.A94997CE@ray>
 <CAKgNAkj8voeBsjERrRq+17L9rK5Vy_quv7Dm_7Hkmuvxfpw_iQ@mail.gmail.com>
 <57FE679D.8010101@intel.com> <558d30e9-e374-728c-2099-ed8eccadf7a2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558d30e9-e374-728c-2099-ed8eccadf7a2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/17/2016 05:04 AM, Michael Kerrisk (man-pages) wrote:
>> The 13 Sep version is the latest version of the man pages.  Those fully
>> describe the functionality that hit mainline and I haven't updated them
>> since 13 Sep.
> 
> Okay -- I've merged these pages. I did a fair bit of editing, mainly
> wording fixes, and textual reorganization, but also adding a few
> details that were missing. Could you take a look at the pkey_alloc(2),
> mprotect(2), and pkeys(7) page that are currently in man-pages
> Git and let me know if anything needs fixing, or if there are any
> details  that it occurs to you still need to be added.

These look good, except for a bit of signal handing description that I
neglected to send.  I'll have a patch out for it momentarily.

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
