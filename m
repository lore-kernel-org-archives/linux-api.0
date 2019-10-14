From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/7] Add a new flags-accepting interface for anonymous inodes
Date: Mon, 14 Oct 2019 20:30:07 +0200
Message-ID: <CAG48ez1Tdm+iz3-H7OZ2v9-zmWg-73zwEsupDxmnEymZM_C3DA@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-2-dancol@google.com>
 <CAG48ez3yOPAC3mTJdQ5_8aARQPe+siid5jaa8U+aMtfj-bUJ2g@mail.gmail.com> <CAKOZuet4VM-P_xm9R7cJO2_f60eUcqt5wHG8+khJedhctfEEhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuet4VM-P_xm9R7cJO2_f60eUcqt5wHG8+khJedhctfEEhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 14, 2019 at 8:16 PM Daniel Colascione <dancol@google.com> wrote:
> On Mon, Oct 14, 2019 at 8:39 AM Jann Horn <jannh@google.com> wrote:
> >
> > On Sat, Oct 12, 2019 at 9:16 PM Daniel Colascione <dancol@google.com> wrote:
> > > Add functions forwarding from the old names to the new ones so we
> > > don't need to change any callers.
> >
> > This patch does more than the commit message says; it also refactors
> > the body of the function. (I would've moved that refactoring over into
> > patch 2, but I guess this works, too.)
> >
> > [...]
> > > -struct file *anon_inode_getfile(const char *name,
> > > -                               const struct file_operations *fops,
> > > -                               void *priv, int flags)
> > > +struct file *anon_inode_getfile2(const char *name,
> > > +                                const struct file_operations *fops,
> > > +                                void *priv, int flags, int anon_inode_flags)
> >
> > (AFAIK, normal kernel style is to slap a "__" prefix in front of the
> > function name instead of appending a digit, but I guess it doesn't
> > really matter.)
>
> I thought prefixing "_" was for signaling "this is an implementation
> detail and you probably don't want to call it unless you know what
> you're doing", not "here's a new version that does a new thing".

Ah, I guess that might be true.
