From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch v4 resend 2/2] kcmp: Add KCMP_EPOLL_TFD mode to compare
 epoll target files
Date: Sat, 13 May 2017 01:53:40 +0300
Message-ID: <20170512225340.GD1881@uranus.lan>
References: <20170424154423.511592110@gmail.com>
 <CAG48ez33xco_cHeaHYg2TOCquosbrAStnHikBDZ89No6c7E0Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez33xco_cHeaHYg2TOCquosbrAStnHikBDZ89No6c7E0Kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, akpm@linuxfoundation.org, avagin@virtuozzo.com, xemul@virtuozzo.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, avagin@openvz.org, jbaron@akamai.com, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Sat, May 13, 2017 at 12:41:30AM +0200, Jann Horn wrote:
> [resending as plaintext]
> 
> I realize that the existing kcmp code has the same issue, but:
> 
> Why are you not taking a reference to filp or filp_tgt? This can end up
> performing a comparison between a pointer to a freed struct file and a
> pointer to a struct file that was allocated afterwards, right? So it can
> return a false "is equal" result when the two files aren't actually the same
> if one of the target tasks is running? This looks like it unnecessarily
> exposes information about whether an allocation reuses the memory of
> a previously freed allocation.

It work with unlocked data on purpose for speed sake. Moreover even
if we grap a reference it is valid _only_ during comparision operation,
next we drop ref and it can be easily freed by os. Thus it's up to
a caller to keep references to files/task and other resources used.

	Cyrill
