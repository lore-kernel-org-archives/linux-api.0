From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
Date: Thu, 27 Jun 2019 18:18:12 +0200
Message-ID: <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
 <20190625225201.GJ17978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-16293-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20190625225201.GJ17978@ZenIV.linux.org.uk>
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S .
 Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kern>
List-Id: linux-api@vger.kernel.org


On 26/06/2019 00:52, Al Viro wrote:
> On Tue, Jun 25, 2019 at 11:52:34PM +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>> +/* must call iput(inode) after this call */
>> +static struct inode *inode_from_fd(int ufd, bool check_access)
>> +{
>> +    struct inode *ret;
>> +    struct fd f;
>> +    int deny;
>> +
>> +    f =3D fdget(ufd);
>> +    if (unlikely(!f.file || !file_inode(f.file))) {
>> +            ret =3D ERR_PTR(-EBADF);
>> +            goto put_fd;
>> +    }
>
> Just when does one get a NULL file_inode()?  The reason I'm asking is
> that arseloads of code would break if one managed to create such
> a beast...

I didn't find any API documentation about this guarantee, so I followed
a defensive programming approach. I'll remove the file_inode() check.

>
> Incidentally, that should be return ERR_PTR(-EBADF); fdput() is wrong the=
re.

Right, I'll fix that.

>
>> +    }
>> +    /* check if the FD is tied to a mount point */
>> +    /* TODO: add this check when called from an eBPF program too */
>> +    if (unlikely(!f.file->f_path.mnt
>
> Again, the same question - when the hell can that happen?

Defensive programming again, I'll remove it.

> If you are
> sitting on an exploitable roothole, do share it...
>
>  || f.file->f_path.mnt->mnt_flags &
>> +                            MNT_INTERNAL)) {
>> +            ret =3D ERR_PTR(-EINVAL);
>> +            goto put_fd;
>
> What does it have to do with mountpoints, anyway?

I want to only manage inodes tied to a userspace-visible file system
(this check may not be enough though). It doesn't make sense to be able
to add inodes which are not mounted, to this kind of map.

>
>> +/* called from syscall */
>> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode =
*key)
>> +{
>> +    struct inode_array *array =3D container_of(map, struct inode_array,=
 map);
>> +    struct inode *inode;
>> +    int i;
>> +
>> +    WARN_ON_ONCE(!rcu_read_lock_held());
>> +    for (i =3D 0; i < array->map.max_entries; i++) {
>> +            if (array->elems[i].inode =3D=3D key) {
>> +                    inode =3D xchg(&array->elems[i].inode, NULL);
>> +                    array->nb_entries--;
>
> Umm...  Is that intended to be atomic in any sense?

nb_entries is not used as a bound check but to avoid walking uselessly
through the (pre-allocated) array when adding a new element, but I'll
use an atomic to avoid inconsistencies anyway.

>
>> +                    iput(inode);
>> +                    return 0;
>> +            }
>> +    }
>> +    return -ENOENT;
>> +}
>> +
>> +/* called from syscall */
>> +int bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
>> +{
>> +    struct inode *inode;
>> +    int err;
>> +
>> +    inode =3D inode_from_fd(*key, false);
>> +    if (IS_ERR(inode))
>> +            return PTR_ERR(inode);
>> +    err =3D sys_inode_map_delete_elem(map, inode);
>> +    iput(inode);
>> +    return err;
>> +}
>
> Wait a sec...  So we have those beasties that can have long-term
> references to arbitrary inodes stuck in them?  What will happen
> if you get umount(2) called while such a thing exists?

I though an umount would be denied but no, we get a self-destructed busy
inode and a bug!
What about wrapping the inode's superblock->s_op->destroy_inode() to
first remove the element from the map and then call the real
destroy_inode(), if any?
Or I could update fs/inode.c:destroy_inode() to call inode->free_inode()
if it is set, and set it when such inode is referenced by a map?
Or maybe I could hold the referencing file in the map and then wrap its
f_op?


--
Micka=C3=ABl Sala=C3=BCn
ANSSI/SDE/ST/LAM

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
