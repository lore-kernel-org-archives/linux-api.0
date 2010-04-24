From: ron minnich <rminnich@gmail.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Sat, 24 Apr 2010 09:25:08 -0700
Message-ID: <n2s13426df11004240925id540ed94mc2ebafada0099ec4@mail.gmail.com>
References: <20100421012749.GA21338@us.ibm.com>
	 <20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	 <20100421034532.GA9254@us.ibm.com> <m1zl0xo1m9.fsf@fess.ebiederm.org>
	 <20100424033614.GA4180@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20100424033614.GA4180@us.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 23, 2010 at 8:36 PM, Serge E. Hallyn <serue@us.ibm.com> wro=
te:

> An fs actually seems overkill for two write-only files for
> process-related information. =A0Would these actually be candidates
> for new /proc files?
>
> =A0 =A0 =A0 =A0/proc/grantcred - replaces /dev/caphash, for privilege=
d
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tasks to tell the kernel about new set=
uid
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0capabilities
> =A0 =A0 =A0 =A0/proc/self/usecred - replaces /dev/capuse for unprivil=
eged
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tasks to make use of a setuid capabili=
ty

An fs is fine.

To relate this to Plan 9, where it all began, might be useful. There's
no equivalent in Plan 9 to Linux/Unix devices of the major/minor
number etc. variety. In-kernel drivers and out-of-kernel servers both
end up providing the services (i.e. file name spaces) that we see in a
Linux file system. So the Plan 9 driver for the capability device
really does match closely in function and interface to a Linux
kernel-based file system.

Hence, making devcap a file system is entirely appropriate, because it
best fits the way it works in Plan 9: a kernel driver that provides
two files.

It's pretty easy to write a Linux VFS anyway, so it makes sense from
that point of view.

Eric, that was a great suggestion.

ron
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
