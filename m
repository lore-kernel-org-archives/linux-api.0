From: Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 07:44:01 -0700
Message-ID: <u2wa67e66b21004210744n48b1b189v2775665c7b2ea77f@mail.gmail.com>
References: <20100421012749.GA21338@us.ibm.com>
	 <20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	 <20100421034532.GA9254@us.ibm.com>
	 <h2na67e66b21004202118w484dd8f0pe526b0a1fc7220e0@mail.gmail.com>
	 <20100421134759.GE16326@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100421134759.GE16326-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 21, 2010 at 6:47 AM, Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wro=
te:
> Quoting Ashwin Ganti (ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>> On Tue, Apr 20, 2010 at 8:45 PM, Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> =
wrote:
>> > Quoting Greg KH (greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org):
>> >> Hm, who is going to maintain this, you, or Ashwin?
>> >
>> > I haven't asked Ashwin, and will be happy either way. =A0Ashwin, d=
id
>> > you want to maintain it?
>>
>> Well, since you have been driving a lot of implementation changes
>> recently, I feel it makes sense for you to be a maintainer. Honestly=
 I
>> don't think I will be able to find time maintaining this in the futu=
re
>> although I can do the code reviews for you. I will be more than happ=
y
>> if this feature continues to get traction.
>>
>> - Ashwin
>
> Ok. =A0I'll put myself in MAINTAINERS. =A0If we stick with the p9auth
> driver or filesystem approach, I'd like to keep you in MODULE_AUTHOR(=
)
> if that's ok, bc it really is yours, and wouldn't exist without you.

Yeah, sure.

- Ashwin
