From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/6] Harden userfaultfd
Date: Tue, 11 Feb 2020 15:27:10 -0800
Message-ID: <CAKOZueuh2MR4UKi60-GVgPkXjncHx8J=mTTjRquB82CfS7DxBA@mail.gmail.com>
References: <20200211225547.235083-1-dancol@google.com> <9ae20f6e-c5c0-4fd7-5b61-77218d19480b@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <9ae20f6e-c5c0-4fd7-5b61-77218d19480b@schaufler-ca.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Tim Murray <timmurray@google.com>, Nosh Minwalla <nosh@google.com>, Nick Kralevich <nnk@google.com>, Lokesh Gidra <lokeshgidra@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, selinux@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 11, 2020 at 3:13 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 2/11/2020 2:55 PM, Daniel Colascione wrote:
> > Userfaultfd in unprivileged contexts could be potentially very
> > useful. We'd like to harden userfaultfd to make such unprivileged use
> > less risky. This patch series allows SELinux to manage userfaultfd
> > file descriptors and allows administrators to limit userfaultfd to
> > servicing user-mode faults, increasing the difficulty of using
> > userfaultfd in exploit chains invoking delaying kernel faults.
> >
> > A new anon_inodes interface allows callers to opt into SELinux
> > management of anonymous file objects. In this mode, anon_inodes
> > creates new ephemeral inodes for anonymous file objects instead of
> > reusing a singleton dummy inode. A new LSM hook gives security modules
> > an opportunity to configure and veto these ephemeral inodes.
> >
> > Existing anon_inodes users must opt into the new functionality.
> >
> > Daniel Colascione (6):
> >   Add a new flags-accepting interface for anonymous inodes
> >   Add a concept of a "secure" anonymous file
> >   Teach SELinux about a new userfaultfd class
> >   Wire UFFD up to SELinux
> >   Let userfaultfd opt out of handling kernel-mode faults
> >   Add a new sysctl for limiting userfaultfd to user mode faults
>
> This must be posted to the linux Security Module list
> <linux-security-module@vger.kernel.org>

Added. I thought selinux@ was sufficient.
