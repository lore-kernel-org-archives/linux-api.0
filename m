From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/
 and make it readable
Date: Mon, 26 Jan 2015 22:50:23 -0800
Message-ID: <20150126225023.df63f6ca.akpm@linux-foundation.org>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<20150114152501.GB9820@node.dhcp.inet.fi>
	<20150114153323.GF2253@moon>
	<20150114204653.GA26698@mail.thefacebook.com>
	<20150114211613.GH2253@moon>
	<20150122024554.GB23762@mail.thefacebook.com>
	<20150124031544.GA1992748@mail.thefacebook.com>
	<20150126124731.GA26916@node.dhcp.inet.fi>
	<20150126210054.GG651@moon>
	<20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
	<20150127064647.GH651@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150127064647.GH651@moon>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Calvin Owens <calvinowens@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Feiner <pfeiner@google.com>, Grant Likely <grant.likely@secretlab.ca>, Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Jan 2015 09:46:47 +0300 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > There's one other problem here: we're assuming that the map_files
> > implementation doesn't have bugs.  If it does have bugs then relaxing
> > permissions like this will create new vulnerabilities.  And the
> > map_files implementation is surprisingly complex.  Is it bug-free?
> 
> I didn't find any bugs in map-files (and we use it for long time already)
> so I think it is safe.

You've been using map_files the way it was supposed to be used so no,
any bugs won't show up.  What happens if you don your evil black hat
and use map_files in ways that weren't anticipated?  Attack it?
