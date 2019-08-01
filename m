From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
Date: Thu, 1 Aug 2019 10:35:36 -0700
Message-ID: <20190801173534.etfls5ltixp5hfrh@ast-mbp.dhcp.thefacebook.com>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
 <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
Sender: netdev-owner@vger.kernel.org
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, LKML <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 31, 2019 at 09:11:10PM +0200, Mickaël Salaün wrote:
> 
> 
> On 31/07/2019 20:58, Alexei Starovoitov wrote:
> > On Wed, Jul 31, 2019 at 11:46 AM Mickaël Salaün
> > <mickael.salaun@ssi.gouv.fr> wrote:
> >>>> +    for (i = 0; i < htab->n_buckets; i++) {
> >>>> +            head = select_bucket(htab, i);
> >>>> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >>>> +                    landlock_inode_remove_map(*((struct inode **)l->key), map);
> >>>> +            }
> >>>> +    }
> >>>> +    htab_map_free(map);
> >>>> +}
> >>>
> >>> user space can delete the map.
> >>> that will trigger inode_htab_map_free() which will call
> >>> landlock_inode_remove_map().
> >>> which will simply itereate the list and delete from the list.
> >>
> >> landlock_inode_remove_map() removes the reference to the map (being
> >> freed) from the inode (with an RCU lock).
> >
> > I'm going to ignore everything else for now and focus only on this bit,
> > since it's fundamental issue to address before this discussion can
> > go any further.
> > rcu_lock is not a spin_lock. I'm pretty sure you know this.
> > But you're arguing that it's somehow protecting from the race
> > I mentioned above?
> >
> 
> I was just clarifying your comment to avoid misunderstanding about what
> is being removed.
> 
> As said in the full response, there is currently a race but, if I add a
> bpf_map_inc() call when the map is referenced by inode->security, then I
> don't see how a race could occur because such added map could only be
> freed in a security_inode_free() (as long as it retains a reference to
> this inode).

then it will be a cycle and a map will never be deleted?
closing map_fd should delete a map. It cannot be alive if it's not
pinned in bpffs, there are no FDs that are holding it, and no progs using it.
So the map deletion will iterate over inodes that belong to this map.
In parallel security_inode_free() will be called that will iterate
over its link list that contains elements from different maps.
So the same link list is modified by two cpus.
Where is a lock that protects from concurrent links list manipulations?

> Les données à caractère personnel recueillies et traitées dans le cadre de cet échange, le sont à seule fin d’exécution d’une relation professionnelle et s’opèrent dans cette seule finalité et pour la durée nécessaire à cette relation. Si vous souhaitez faire usage de vos droits de consultation, de rectification et de suppression de vos données, veuillez contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez reçu ce message par erreur, nous vous remercions d’en informer l’expéditeur et de détruire le message. The personal data collected and processed during this exchange aims solely at completing a business relationship and is limited to the necessary duration of that relationship. If you wish to use your rights of consultation, rectification and deletion of your da
 ta, please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message in error, we thank you for informing the sender and destroying the message.

Please get rid of this. It's absolutely not appropriate on public mailing list.
Next time I'd have to ignore emails that contain such disclaimers.
