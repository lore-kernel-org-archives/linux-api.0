From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFCv3] add manpages for Memory Protection Keys
Date: Fri, 3 Jun 2016 13:26:08 -0700
Message-ID: <5751E7E0.5070001@intel.com>
References: <1464826600-17110-1-git-send-email-dave.hansen@intel.com>
 <647d23bf-a163-deee-d0ec-f961ecfb0b90@gmail.com> <57519A04.5020700@intel.com>
 <d5ce21ad-ec2c-5a56-dde2-7cbd62dd2c49@gmail.com>
 <2c4a4bff-7907-9c2d-389a-5bf987a14ad6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2c4a4bff-7907-9c2d-389a-5bf987a14ad6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave-gkUM19QKKo4@public.gmane.org
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/03/2016 12:35 PM, Michael Kerrisk (man-pages) wrote:
>> > So, I have a suggestion. How about tightening the constraint here, so
>> > that only one of these flags is allowed for now. (EINVAL if both
>> > are specified.) That constraint could always be relaxed later , if
>> > desired, and adding it now may allow some wriggle room later in terms
>> > of modifying the API or allowing for different architectural choices.
> Another reason to give an error for this case: if the user does
> this, they were probably confused. An error let's them know
> they did something nonsensical...

The real benefit of doing it this way is that it allows applications to
add or remove write or access permissions independently of what the
previous permissions were.

For instance, I would expect code to be structured with pairs of
enable/disable operations, like:

int read_something(void)
{
	int ret;
	pkey_access_enable(pkey);
	ret = *some_pkey_memory; // Is this readable or writable?
	pkey_access_disable(pkey);
	return ret;
}

If we do what you suggest, we need to have the program keep extra state
about whether the 'some_pkey_memory' should be write-disabled once
access-enabled.  If we leave it as-is, we get the benefit of the
PKRU[].WD disable bit to do this for us.

In other words, if an application does a pkey_write_disable(), the app
can reasonably expect that *no* writes will be allowed until the app
does a pkey_write_enable().
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
