From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V32 27/27] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Thu, 4 Apr 2019 13:09:20 -0700
Message-ID: <CACdnJuurDF91MyJsngup=Xn+qShqxEqf_w1mEd7RFH5RLTWCgA@mail.gmail.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
 <20190404003249.14356-28-matthewgarrett@google.com> <20190404093907.153f52a8@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404093907.153f52a8@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 4, 2019 at 6:39 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed,  3 Apr 2019 17:32:49 -0700
> Matthew Garrett <matthewgarrett@google.com> wrote:
>
>
> > +static void tracefs_destroy_inode(struct inode *inode)
> > +{
> > +     if S_ISREG(inode->i_mode)
>
> Can we please put parenthesis around the condition. I know that the
> macro has them, but no other place in the kernel plays such a trick.

Ha, I've been spending too much time in Go lately. Fixed.
