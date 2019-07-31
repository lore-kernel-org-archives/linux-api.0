From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type: inode
Date: Wed, 31 Jul 2019 11:58:18 -0700
Message-ID: <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
References: <20190721213116.23476-1-mic@digikod.net> <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com> <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, LKML <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 31, 2019 at 11:46 AM Micka=C3=ABl Sala=C3=BCn
<mickael.salaun@ssi.gouv.fr> wrote:
> >> +    for (i =3D 0; i < htab->n_buckets; i++) {
> >> +            head =3D select_bucket(htab, i);
> >> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >> +                    landlock_inode_remove_map(*((struct inode **)l->k=
ey), map);
> >> +            }
> >> +    }
> >> +    htab_map_free(map);
> >> +}
> >
> > user space can delete the map.
> > that will trigger inode_htab_map_free() which will call
> > landlock_inode_remove_map().
> > which will simply itereate the list and delete from the list.
>
> landlock_inode_remove_map() removes the reference to the map (being
> freed) from the inode (with an RCU lock).

I'm going to ignore everything else for now and focus only on this bit,
since it's fundamental issue to address before this discussion can
go any further.
rcu_lock is not a spin_lock. I'm pretty sure you know this.
But you're arguing that it's somehow protecting from the race
I mentioned above?
