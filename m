From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 02/25] vfs: Allow fsinfo() to query what's in an fs_context [ver #13]
Date: Fri, 21 Jun 2019 15:16:04 +0200
Message-ID: <E76F5188-CED8-4472-9136-BDCDFDAF57F0@brauner.io>
References: <20190621094757.zijugn6cfulmchnf@brauner.io> <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk> <155905627927.1662.13276277442207649583.stgit@warthog.procyon.org.uk> <21652.1561122763@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21652.1561122763@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On June 21, 2019 3:12:43 PM GMT+02:00, David Howells <dhowells@redhat=2Ecom=
> wrote:
>Christian Brauner <christian@brauner=2Eio> wrote:
>
>> >  static int vfs_fsinfo_fd(unsigned int fd, struct fsinfo_kparams
>*params)
>> >  {
>> >  	struct fd f =3D fdget_raw(fd);
>>=20
>> You're using fdget_raw() which means you want to allow O_PATH fds but
>> below you're checking whether the f_ops correspond to
>> fscontext_fops=2E If it's an O_PATH
>
>It can't be=2E  The only way to get an fs_context fd is from fsopen() or
>fspick() - neither of which allow O_PATH to be specified=2E
>
>If you tried to go through /proc/pid/fd with open(O_PATH), I think
>you'd get
>the symlink, not the target=2E

Then you should use fdget(), no? :)

Christian
