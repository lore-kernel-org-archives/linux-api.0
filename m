From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/
 and make it readable
Date: Wed, 28 Jan 2015 00:46:05 +0300
Message-ID: <54C8071D.7030103@parallels.com>
References: <20150114152501.GB9820@node.dhcp.inet.fi>	<20150114153323.GF2253@moon>	<20150114204653.GA26698@mail.thefacebook.com>	<20150114211613.GH2253@moon>	<20150122024554.GB23762@mail.thefacebook.com>	<20150124031544.GA1992748@mail.thefacebook.com>	<20150126124731.GA26916@node.dhcp.inet.fi>	<20150126210054.GG651@moon>	<20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>	<CAGXu5jLDkg0hJSMm3CdoO-77yiK5GQWHSe3+1h7mq76LERpNBA@mail.gmail.com>	<20150127073713.GJ651@moon> <CAGXu5jJFFib7F7uKYgvX4ecyMnbincd22FaO_bFy=VRVKdFbvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJFFib7F7uKYgvX4ecyMnbincd22FaO_bFy=VRVKdFbvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Calvin Owens <calvinowens@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Feiner <pfeiner@google.com>, Grant Likely <grant.likely@secretlab.ca>, Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Pavel Emelyanov <xemul@openvz.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


>>> Are mount namespaces handled in this output?
>>
>> Could you clarify this moment, i'm not sure i get it.
> 
> I changed how I asked this question in my review of the documentation,
> but it looks like these symlinks aren't "regular" symlinks (that are
> up to the follower to have access to the file system path shown), but
> rather they bypass VFS. As a result, I'm wondering how things like
> mount namespaces might change this behavior: what is shown, the path
> from the perspective of the target, or from the viewer (which may be
> in separate mount namespaces).

These work just like the /proc/$pid/fd/$n links do. When you readlink
on it the d_path() is called which walks up the dentry/vfsmnt tree
until it reaches either current root or the global one. For "another"
mount namespace case it produces the path relative to this namespace's
root.

Thanks,
Pavel
