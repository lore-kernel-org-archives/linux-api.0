From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
Date: Sun, 8 Sep 2019 23:19:54 +0100
Message-ID: <20190908221954.GD1131@ZenIV.linux.org.uk>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <894922a2-1150-366c-3f08-c8b759da0742@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <894922a2-1150-366c-3f08-c8b759da0742@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 09, 2019 at 12:09:57AM +0200, Mickaël Salaün wrote:

> >>> +    rcu_read_lock();
> >>> +    ptr = htab_map_lookup_elem(map, &inode);
> >>> +    iput(inode);

Wait a sec.  You are doing _what_ under rcu_read_lock()?

> >>> +    if (IS_ERR(ptr)) {
> >>> +            ret = PTR_ERR(ptr);
> >>> +    } else if (!ptr) {
> >>> +            ret = -ENOENT;
> >>> +    } else {
> >>> +            ret = 0;
> >>> +            copy_map_value(map, value, ptr);
> >>> +    }
> >>> +    rcu_read_unlock();
