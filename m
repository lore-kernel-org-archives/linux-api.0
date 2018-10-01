From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC 0/2] ns: introduce binfmt_misc namespace
Date: Sun, 30 Sep 2018 21:45:44 -0700
Message-ID: <CALCETrWcQtLTVJU14ytWxu_gqoLuAYZJpyAvRsKwwgYZz7FEFg@mail.gmail.com>
References: <20180930234628.25528-1-laurent@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930234628.25528-1-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: laurent@vivier.eu
Cc: LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, Andrey Vagin <avagin@openvz.org>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sun, Sep 30, 2018 at 4:47 PM Laurent Vivier <laurent@vivier.eu> wrote:
>
> This series introduces a new namespace for binfmt_misc.
>

This seems conceptually quite reasonable, but I'm wondering if the
number of namespace types is getting out of hand given the current
API.  Should we be considering whether we need a new set of namespace
creation APIs that scale better to larger numbers of namespace types?
