Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795036380;
	b=sCpXHCv17MqO7ZKuzqQL/zoGKMIpOSgTafDQ58EzhI9lvZRkQ7Dihb7zPCTQrlsvUSRz
	 Er4iIY21pSoGoUGoskjC8wgUu39ZGWYBA+6Un9EZagpO9tY2+HC6RV2GhHq2GzRFWQKZG
	 O1dKLy/Ie1x+ttH+wi7PEDk99IPag4Fko040NzuG0SdSt/W/SBgYRFd09qbaQ6l5pYtG4
	 8OWpUfFn13sNOIa/cJjq22QG4T6D+/RXMb833vMc9+fwyoB7NYuu3sYvjDgLPGi7oygvE
	 /F4eokQp2m6HOxilSJNn2EpRcAyLEZrj11znUpUnUVJYmNbdAZl7RfQAMa8pxiUBcyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UWi6aWIYE+fT8OrBO2DRorgL1+pOEdt+mwu8bkfCsP8=;
	b=xvN/MbVxWv42SvZKFZbgzumCZVHWzu/5Ao2n/RfcfZzN7/L9YoAOrkD2bfds73vBYnak
	 QFh08LF9ufbbxiP68s60MNbheM9QghGZ4pNsq2ZMlNGVNrTDlFqhrp82UAdICeEG/WRfY
	 ardNs/QhhDGLSNLyj5WH1ewfTnFyFlsswVdr7UQlFdGbKJJrr7HVdIruKkuJwkzx5DLpK
	 JpJi2Fopo0DZEEsEGoL0Xe+Dz0cHSPoW8YCixev+F1gDZ1emnVdfhaqSeC97rD3FHHA/F
	 7SyrPG+FIGyQ7w11fOnPaZupuvXU8lXSFFOU1wWSJ0r9w5DGLyxTgmsodIJeVBekVgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F71D606A333
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 21:12:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F71D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5c1a3374400so1069850e87.2
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 13:12:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795036378; cv=none;
        d=google.com; s=arc-20260327;
        b=L4ZbNmNE+iIu0zghq3HIpJJzFYhdPk5rQlxrFTnMqbjq5tsZ15pFDHwHGPGEP/2yt1
         tXrW591CDbnz57KRXV2UFMJa/v/aC/kNB934ag9R/75Y3NsmvMCZabhEcz7p6/+KGerB
         PuYN0U40+UpjZGKJWvVonpCjniXWJeohMosBSgjNKmb8c35J7vZLKTlRjBZHRUcKoold
         mekVXCZyKaoOEGMH4guZsPT6kSchFHxwSC82dJ+A9eMVJC1eATMSfduEadmhmjFwlGFU
         qbRlnKQu11nCrKqkMI6UCdPsw4RH9eq8iYw796vkV2SQ66LqVu2oovqVKCAwIjcmFv6Z
         NN0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UWi6aWIYE+fT8OrBO2DRorgL1+pOEdt+mwu8bkfCsP8=;
        fh=0nJ+MKcKxKStiVFXQ3olD/CuHZuXwhN3O4bv1npMQ5w=;
        b=GIx36Qx0p2xn1luX7wuIqpCyePQNxN1SSWy8/N5b+DSzWXDpPLp9zK7yMgJ9O0ozgG
         3EfM+34u7RfrFmh94OiulEvjL74dzKEu3Q0aIhJvEHIeBnE5AUBIChb4eAWQS+jwZfaO
         vY4pGwnmehP4akAN8sk0vYuyihX0oUmUUF7IcbYoamupyvAAb3DnSgybZOzz8X07gGZ1
         sySb75OugswbJ0BN4JcfCrTotmWvSycHY9hp77jcGM6HxdcRIra7j7AuqyrbkN1ye1pR
         KHCL6WFQMYVkEFViFeofh56HH7+xJg8wZcj6OMYASHs1q33lwYRfRg8fUZTykAtskhjW
         SXVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795036378; x=1795641178; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UWi6aWIYE+fT8OrBO2DRorgL1+pOEdt+mwu8bkfCsP8=;
        b=kgM+94wMeRVtqQuKMf2voBlp/7mmBGB0wg6RbakCJoZIUyenSlHL3LjFrlxAtFmRFC
         S8KP6bDmaJ7+KmKrve9oF+DO15q0bbfeomzd2ANxZbMI9Wp5wEKb9CT/PHzw6w7N6PcZ
         GWqEGss6hqHZ6qOh4V5IDyC8g4dQFp55046Gobv711dFigyzVlHjLWJxvrwr4Q6yCm7l
         rXKICef3dz7+oPENdL0yQHlDHryjcIFh5nBw5N/VbP4d6AEEi/4vp9fZgJ5mH/3XitRH
         0F8PFxwchkMjqaIbMoygjydckD09A1fliBgC9Y1ht0h3X+h9AJLtWZf4e+6lb1uNuTx/
         xa1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036378; x=1795641178;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWi6aWIYE+fT8OrBO2DRorgL1+pOEdt+mwu8bkfCsP8=;
        b=Mh4TQ+4Hkb8ZwqWgeOIU3zUz8Ad3F6ycqZwSGYXFv1g855jeydfPssU1O+1h8Cj8o9
         BtG7wy375lMZ0IeEYi+dYU6BQ3A/b9VAypSG/fReTktDqn5EkDHmpRqGPH8ylp/iSDVb
         b0vCNe0s32Zm0nKMpMpdg0dDUUxVh8RJsoJ4EKN2LK24rsRTFhFR2ISCmQ1/aYJK1vkk
         Yxak3Lwd5Y3xOR2qxh+keoQ0ZOu5uL3lXLpcNRNJnDFd1/GtHMSXWPqf9viL53BSn/AQ
         W/5HUOni5pM3w2g3b8hhvsPlOlcBVl8z6tcSSfdtiLHBm5TlyGyqNujyUEoXy1aLK6A0
         Dnhg==
X-Forwarded-Encrypted: i=1; AL+hErHk/1jEZweKdzdqvbxuh+bkR7UrV35/z3o0050pIyanLGNJdd7RntueA/wmUV70F6Ef30tFmnATfI4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/kyTTW6S9Kkwc2hWutKiXMi4jz9PJ1N0iQSJ/CHTfIaLl5lA0y
	NXUZnZ68en3PkZV8Kef/XAIPipFuv//fvMQZa/PwMA/z3azzKGsasa7FbsCn7xXIOYhDchzaLhf
	Sl89hRiZdN81G6zpGbK7yZgLC2B7VPe4FtUsg8OAE
X-Gm-Gg: AYBFou2QTiM/Kqy2R8sxvrYggGogTlkcf/7wMB3pJXVBUBUl2RNF/eKT3rI4GSscwNf
	DYIIdLqBgkOI0efmtxbmsQzcM1DWFYehpmYXZ6l+MO9RoA8WCqbn+JQUlOyq5GsnC9YXJEwKRHz
	6dVF0/asunL1nRJ6bXmbWQ1DxBH9Ea5YtWdpsMP5i5GPNh3PLEeYA4IHJh51NFdu+zIh5UaLOFP
	5np/wuqGtuJ0SgKz/O/ZtpqFo6Kb8A6ufgmy4vbm12D7UP0ubQbaXPVQ9cydAksiFF3gULQbB/1
	UqWwQz9KyW4n3OwJarw+H8QqjiUN1EDfv//K+oP3QZaw7hC4SEltDKlC4aLqFr9cXPVV8Ccusfn
	qkWz5QyAdP+OCSfUqa4zgSZPaM5Y8hgYJkw==
X-Received: by 2002:a05:6512:2387:b0:5c0:209:a85f with SMTP id
 2adb3069b0e04-5c1a9c1b551mr1282932e87.25.1795036377561; Wed, 18 Nov 2026
 13:12:57 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com> <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner> <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com> <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
 <CALCETrUjW=kXxyggDUvEN+Pxc-pE98eVbdW8XBU8JzfqXj_voA@mail.gmail.com>
 <20261117-rational-ohnehin-unbeugsam-e5c04759a156@brauner>
 <CALCETrWhuOnBy0N0KznmczD4S2XEK0fbr0C=1KFQqTnoTJbQbg@mail.gmail.com>
 <20261118-stapeln-eckpunkte-lesbar-ee73537f474d@brauner> <20261118-zufahrt-baubeginn-gutsbetrieb-c09004227e8f@brauner>
In-Reply-To: <20261118-zufahrt-baubeginn-gutsbetrieb-c09004227e8f@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Nov 2026 13:12:45 -0800
X-Gm-Features: Aa3M54o7fZB1Cpe0ST_SUtYpCXQerdKYt_ETG0v-G2QE_rfSU2Am1PRKK-TPOCc
Message-ID: <CALCETrUMNr=32ENT6VBKPzoyJDfaX6nzZsjMVxuz9O3z+6LRhw@mail.gmail.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
To: Christian Brauner <brauner@kernel.org>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	KP Singh <kpsingh@kernel.org>, Jonathan Calmels <jcalmels@3xx0.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 1:06=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Wed, Nov 18, 2026 at 11:21:57AM +0100, Christian Brauner wrote:
> > On Tue, Nov 17, 2026 at 09:37:19AM -0800, Andy Lutomirski wrote:
> > > On Tue, Nov 17, 2026 at 9:10=E2=80=AFAM Christian Brauner <brauner@ke=
rnel.org> wrote:
> > > >
> > > > On Mon, Nov 16, 2026 at 09:15:18AM -0800, Andy Lutomirski wrote:
> > > > > On Wed, Nov 11, 2026 at 7:20 AM Christian Brauner <brauner@kernel=
.org> wrote:
> > > > > > * a task that setns()es in later gets
> > > > > >   ns->cap_bset & (cred->cap_userns | cred->cap_permitted)
> > > > >
> > > > > I'm not sure this is ideal.  If a task has cap_userns & CAP_NET_A=
DMIN,
> > > > > then there is no attack surface issue with allowing it to enter a
> > > > > namespace and be NET_ADMIN there even if the namespace itself has
> > > > > CAP_NET_ADMIN cleared from cap_bset.  But any exemption here woul=
d
> > > > > need to be a new API so that it isn't used by accident.
> > > > >
> > > > > I'm mostly saying this because container managers might want to
> > > > > restrict cap_userns within their containers but still have it
> > > > > themselves for management.  But maybe there isn't any need to ent=
er
> > > > > the userns for this purpose.
> > > >
> > > > I don't think there is. A manager that holds the capabilities itsel=
f can
> > > > just do most things from the outside. I think it's nice that once y=
ou're
> > > > inside a namespace you're bound by its capabiltiy set. Otherwise th=
e set
> > > > isn't a property of the namespace anymore. If someone comes up with=
 a
> > > > real need to enter we can add an explicit opt-in later?
> > >
> > > Fair enough.  Also you've written infinitely more nontrivial containe=
r
> > > managers than I have (I've written container managers, too, but
> > > they're all special-purpose things that don't do much in the way of
> > > actual managing).
> >
> > So I think this is another instance where we're bitten by the complexit=
y
> > of the whole namespace api. In a perfect world our answer would be "Yes=
,
> > the owner of the userns is definitely capable of performing all relevan=
t
> > actions from outside the userns.". But we're actually not able to say
> > that because there's so many different ways how some <object> is set up
> > or configured for a container and nobody ever sat down and defined the
> > model how a container and it's various resoures are set up.
> >
> > So once again, here we are guessing our way to a decent decision...
> > Thanks for helping with thinking this through.
> >
> > > > > > * Root in a container has caps as well so for containers the ex=
emption
> > > > > >   would be wrong.
> > > > > >
> > > > > >   So here we need a a lockable SECURE_NO_USERNS_CAP_RAISE bit t=
hingy.
> > > > > >   This turns off the exemption and prevents raising the mask.
> > > > > >
> > > > > >   Docker lowers the mask, sets and locks the bit, and
> > > > > >   unshare(CLONE_NEWUSER) in the container doesn't hand out CAP_=
NET_ADMIN
> > > > > >   anymore.
> > > > >
> > > > > Can you clarify this part a bit?  I'm not seeing why Docker shoul=
d be
> > > > > special.  Shouldn't the inside of a Docker container work as much=
 like
> > > > > a normal non-container system as possible?  What's the use case?
> > > >
> > > > I picked Docker because you brought it up, and your goal of allowin=
g
> > > > user namespaces even in Docker is kinda the use case. Docker can on=
ly
> > > > drop the CLONE_NEWUSER block from its seccomp profile if nested use=
r
> > > > namespaces can't get more caps than root/Docker wants to give them.
> > > >
> > > > But the bit isn't at all Docker specific. Any privileged task that =
wants the
> > > > mask to apply to itself would benefit. With just the exemption this=
 wouldn't be
> > > > possible:
> > > >
> > > > (1) A runtime that holds full capabilities gives a
> > > >     user namespace it creates all bits.
> > > >     It can just set the bit before creating it.
> > > >
> > > > (2) In a container without a user namespace container root has host=
-level
> > > >     capabilities. Any user namespace it creates gets them through t=
his
> > > >     exemption thing. So it can also add them back to its mask. And =
the mask is
> > > >     inherited. So every process it starts can then create user name=
spaces with
> > > >     them.
> > > >
> > > >     by raising the bit we stop both. The locked bit keeps container=
 root which
> > > >     also has CAP_SETPCAP from clearing it.
> > > >
> > >
> > > I'm still not 100% sure I'm following this.  By "exemption" are you
> > > talking about the cred->cap_premitted term here?
> >
> > Yes.
> >
> > > ns->cap_bset =3D parent->cap_bset &
> > >                        (cred->cap_userns | cred->cap_permitted);
> > >
> > > (As as aside, as formulated, the parent->cap_bset term should be
> > > irrelevant, no?  cred always refers to a task in parent, and this
> >
> > (
> > I don't think it i.s
> > cap_userns is full by default. Entering a namespace doesn't change it.
> > A task inside a namespace with a reduced cap_bset still has the full
> > mask. Without the term a child namespace gets more caps than its parent
> > had.
> >
> > cap_permitted can grow through a setuid-root exec in the parent
> > namespace. And that exec is bounded by the tasks bounding set and not
> > by the namespace bounding set.
> >
> > So that term ensures that the namespace bounding set shrinks
> > monotonically by construction.
> >
> > I think it would only be redundant if exec would be clamped by cap_bset=
.
> > I'm not sure if the patchset does this.
> >
> > /me looks...
> >
> > Ah, ok... this patch series already clamps exec to the namespace
> > bounding set. So yes, you're right.
> > )
> >
> > > whole thing is defined so that cap_userns and cap_permitted are alway=
s
> > > subsets of parent's cap_bset, right?)
> > >
> > > I think I agree that there needs to be a way to turn the cap_permitte=
d
> > > thing on and off (and I'm also not sure whether cap_permitted is
> > > better than cap_effective), but I'm not convinced that an inheritable
> >
> > The effective set can be raised from the permitted set at will. So I
> > think permitted is just more correct.
> >
> > > and lockable bit is necessary or wise.
> > >
> > > How about changing the rule to:
> > >
> > > child->cap_bset =3D parent->cap_bset & soft_cap_userns &
> > > (cred->cap_userns | cred->cap_permitted)
> > >
> > > a) (ugly but easier) A non-inheritable prctl-controlled mask
> > > soft_cap_userns, changing the rule to parent->cap_bset &
> > > soft_cap_userns & (cred->cap_userns | cred->cap_permitted).
> > > soft_cap_userns would be reset to all ones on on fork and exec to
> > > avoid creating new inheritable security-relevant state.
> >
> > So both let the creator pick. But the bit is for the creator when it
> > wants to self-restrict: container-root without a user namespace.
> >
> > It's the same reason that securebits and no_new_privs are inheritable
> > and lockable. Afaict, a) is reset on exec so it doesn't control the nex=
t
> > exec. b) covers namespace creation but not unsharing a user namespace.
> >
> > > b) A whole new create-a-namespace API where the caller chooses
> > > soft_cap_userns at the time they create the namespace.
> > >
> > > > On the host none of that matters as the mask is root's own policy t=
here.
> > >
> > > I'm still not seeing how there's a difference between host vs
> > > init-userns-container vs separate-userns-container.  After all, in
> >
> > I think the difference is simply whether the restricting task holds the
> > capabilities itself. Unprivileged users on the host don't and so they'r=
e
> > not subject to the exemption. The bit is for that case where the task
> > holds the caps.
> >
> > But ok, if we really don't want to bother with container without user
> > namespaces the bit vs a) thing can also go into a follow-up series.
> >
> > > Unfortunately we don't live in this world, and I'm not convinced that
> > > can credibly even approximate it, because people really like their
> > > setuid programs working inside a userns.  It still bugs me that we're
> > > designing permission systems designed to work in the POSIX model that
> > > I think we all kind of agree is fundamentally rather messed up.
> >
> > I don't think all hope is lost. We have slowly been pushing in this
> > direction. systemd allows to set NoNewPrivileges=3D in it's global conf=
ig
> > so it's possible to enable it for the whole system easily.
> >
> > There's been a ton of work to get rid of classic setuid-exec stuff:
> >
> > * run0 instead of sudo (with sudo compat), and systemd-ptybrokerd for
> >   interactive shells
> > * nsresourced for user namespaces with delegated ranges, mountfsd for
> >   unprivileged image mounts
> > * outside of systemd: pwaccessd/pwupdd/newidmapd replacing unix_chkpwd,
> >   passwd and newuidmap/newgidmap, polkit without a setuid helper, and
> >   su/sudo/pkexec wrappers on top of ptybrokerd
> >
> > But yes, containers are the sore spot. no_new_privs inherited from PID
> > 1 breaks setuid inside of containers.
> >
> > My idea has been to make this dynamic:
> >
> > * deny privilege gain on exec in the initial user namespace and allow i=
t
> >   in nested ones. I mused about this in
> >   https://github.com/uapi-group/kernel-features/pull/38
> >
> > Also, since v7.1 there's CLONE_NNP to spawn a child without no_new_priv=
s
> > set.
>
> Forgot:
>
> https://www.thkukuk.de/blog/no_new_privs/
>
> has an overview of where we're currently at.

Nice!

I commented in the uapi-group issue:

I think there may be a rather more direct solution to this problem. I
seem to recall advocating for clearing no_new_privs when entering a
userns way back when, and IIRC I dropped this as part of the extensive
negotiation to get NNP into the kernel in the first place. (I think
dropping it was probably the right decision to keep the final patch
simple.)

But I think I would still advocate for an option to let clone, unshare
and setns callers turn no_new_privs off. The logic is that, if you own
a userns, you already have all capabilities in it. If you enter it,
you get to keep those by having them raised in cap_permitted. Being
able to clear NNP and thus drop and subsequently regain them does not
let you do anything you couldn=E2=80=99t already do.

An LSM hook for this would be needed because this argument does not
apply to non-namespace-scoped LSM-based privileges. But the LSM hook
would just be a "may this caller enter this userns and clear
no_new_privs while doing so" query. In the absence of LSMs, the
operation would be allowed.

This would allow a fully no_new_privs host to run an ordinary
container that runs, in the ordinary way, without no_new_privs, and
without hitting any new LSM calls after it's started.

The API could be as simple as a CLONE_CLEAR_NNP bit.


--=20
Andy Lutomirski
AMA Capital Management, LLC
