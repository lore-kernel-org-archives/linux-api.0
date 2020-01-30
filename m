From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Thu, 30 Jan 2020 15:47:06 +0100
Message-ID: <0b72d000-02be-9974-900f-d94af1cbc08a@samba.org>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
 <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Ya6c79fzMX3lTarynsMKTGIbpvRs0Sh78"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cf801c52-7719-bb5c-c999-ab9aab0d4871-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ya6c79fzMX3lTarynsMKTGIbpvRs0Sh78
Content-Type: multipart/mixed; boundary="GdkL4c4WY4m2c8z7llVJO3pkMDsYXRIqN";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
 Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
 Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <0b72d000-02be-9974-900f-d94af1cbc08a-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
 <cf801c52-7719-bb5c-c999-ab9aab0d4871-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
In-Reply-To: <cf801c52-7719-bb5c-c999-ab9aab0d4871-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--GdkL4c4WY4m2c8z7llVJO3pkMDsYXRIqN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 30.01.20 um 15:11 schrieb Jens Axboe:
> On 1/30/20 3:26 AM, Christian Brauner wrote:
>> On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
>>> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
>>>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>>>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote=
:
>>>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>>> [...]
>>>>>>>>> #1 adds support for registering the personality of the invoking=
 task,
>>>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's lim=
ited to
>>>>>>>>> just having one link, it doesn't support a chain of them.
>>>>>> [...]
>>>>>>> I didn't like it becoming a bit too complicated, both in terms of=

>>>>>>> implementation and use. And the fact that we'd have to jump throu=
gh
>>>>>>> hoops to make this work for a full chain.
>>>>>>>
>>>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY=
=2E
>>>>>>> This makes it way easier to use. Same branch:
>>>>>>>
>>>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-=
vfs-creds
>>>>>>>
>>>>>>> I'd feel much better with this variant for 5.6.
>>>>>>
>>>>>> Some general feedback from an inspectability/debuggability perspec=
tive:
>>>>>>
>>>>>> At some point, it might be nice if you could add a .show_fdinfo
>>>>>> handler to the io_uring_fops that makes it possible to get a rough=

>>>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/=
$fd,
>>>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>>>>> helpful for debugging to be able to see information about the fixe=
d
>>>>>> files and buffers that have been registered. Same for the
>>>>>> personalities; that information might also be useful when someone =
is
>>>>>> trying to figure out what privileges a running process actually ha=
s.
>>>>>
>>>>> Agree, that would be a very useful addition. I'll take a look at it=
=2E
>>>>
>>>> Jann, how much info are you looking for? Here's a rough start, just
>>>> shows the number of registered files and buffers, and lists the
>>>> personalities registered. We could also dump the buffer info for
>>>> each of them, and ditto for the files. Not sure how much verbosity
>>>> is acceptable in fdinfo?
>>>
>>> At the moment, I personally am just interested in this from the
>>> perspective of being able to audit the state of personalities, to mak=
e
>>> important information about the security state of processes visible.
>>>
>>> Good point about verbosity in fdinfo - I'm not sure about that myself=
 either.
>>>
>>>> Here's the test app for personality:
>>>
>>> Oh, that was quick...
>>>
>>>> # cat 3
>>>> pos:    0
>>>> flags:  02000002
>>>> mnt_id: 14
>>>> user-files: 0
>>>> user-bufs: 0
>>>> personalities:
>>>>             1: uid=3D0/gid=3D0
>>>>
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index c5ca84a305d3..0b2c7d800297 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -6511,6 +6505,45 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,=
 fd, u32, to_submit,
>>>>         return submitted ? submitted : ret;
>>>>  }
>>>>
>>>> +struct ring_show_idr {
>>>> +       struct io_ring_ctx *ctx;
>>>> +       struct seq_file *m;
>>>> +};
>>>> +
>>>> +static int io_uring_show_cred(int id, void *p, void *data)
>>>> +{
>>>> +       struct ring_show_idr *r =3D data;
>>>> +       const struct cred *cred =3D p;
>>>> +
>>>> +       seq_printf(r->m, "\t%5d: uid=3D%u/gid=3D%u\n", id, cred->uid=
=2Eval,
>>>> +                                               cred->gid.val);
>>>
>>> As Stefan said, the ->uid and ->gid aren't very useful, since when a
>>> process switches UIDs for accessing things in the filesystem, it
>>> probably only changes its EUID and FSUID, not its RUID.
>>> I think what's particularly relevant for uring would be the ->fsuid
>>> and the ->fsgid along with ->cap_effective; and perhaps for some
>>> operations also the ->euid and ->egid. The real UID/GID aren't really=

>>> relevant when performing normal filesystem operations and such.
>>
>> This should probably just use the same format that is found in
>> /proc/<pid>/status to make it easy for tools to use the same parsing
>> logic and for the sake of consistency. We've adapted the same format f=
or
>> pidfds. So that would mean:
>>
>> Uid:	1000	1000	1000	1000
>> Gid:	1000	1000	1000	1000
>>
>> Which would be: Real, effective, saved set, and filesystem {G,U}IDs
>>
>> And CapEff in /proc/<pid>/status has the format:
>> CapEff:	0000000000000000
>=20
> I agree, consistency is good. I've added this, and also changed the
> naming to be CamelCase, which is seems like most of them are. Now it
> looks like this:
>=20
> pos:	0
> flags:	02000002
> mnt_id:	14
> UserFiles:     0
> UserBufs:     0
> Personalities:
>     1
> 	Uid:	0		0		0		0
> 	Gid:	0		0		0		0
> 	Groups:	0
> 	CapEff:	0000003fffffffff
>=20
> for a single personality registered (root). I have to indent it an extr=
a
> tab to display each personality.

That looks good.

Maybe also print some details of struct io_ring_ctx,
flags and the ring sizes, ctx->cred.

Maybe details for io_wq and sqo_thread.

Maybe pending requests?
I'm not sure about how io_wq threads work in detail.
Is it possible that a large number of blocking request
(against an external harddisk with disconnected cable)
to block other blocking requests to a working ssd?
It would be good to diagnose such situations from
the output.

How is this supposed to be ABI-wise? Is it possible to change
the output in later kernel versions?

metze


--GdkL4c4WY4m2c8z7llVJO3pkMDsYXRIqN--

--Ya6c79fzMX3lTarynsMKTGIbpvRs0Sh78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4y7GoACgkQDbX1YShp
vVasfBAAn4CNi7nFcXzGA6QVT35ax5zpRB1j+DL+GM5x5p40GpnzoZSkkbkJyHKv
9vSg8dPuTV+bJtqEBxDz4so6MsHd5vlcmIwiDIyZUgJzhuubW60anC5gBo8hIOFS
GZRwRRdoJqWL2fSKAYG0gGZj5cbSti24Rr6kggikm6DOix82tlcHVC6n0qmRCYCF
A0fMYDvsmwFKk32MvkAkSnpqsmQuz2VKYqIh4kg6VR1w3DpJZ5uKdlJ0nzoHlMSr
4cBF7o0JyrXFxa+GPbOGS6QxRjva9OkE/SsdllPah3BJH4q0vYdDiaojTsZibLI7
MsPvJlDs6vgLHgsIuHhoMSWMoVmkE4TRBUZiFcDOGEsQpcWd9pjMBudgLm8r2vsb
AddZTAsiFNSb9thK3zBA+HZNg49Kj4YY3Wzl/OGFF22biOYkjZmhseR5zAUblJ2a
3RiRFWtlW8z+kU+ePbd5iS2jRars6+a+9sUdpDwFTiaOHOwGaZByyUSgtXELHfZJ
16wqGkssNqRwpFS56akOv0VuWkv3zlUOxc63F9sZSdH/0UVMy1PH7Qn9X3TmK3XX
QguGJKiOk6mnxGQpeF5NSKqCfyGUPJVBw585ttj3qSoq+TzyvGeA7foUG5bd74TH
4oC3+/z0hYsBYVaN7bG8i0mv3JVjbwhhJWHsTtAAl8rajlDwrJ8=
=Y8da
-----END PGP SIGNATURE-----

--Ya6c79fzMX3lTarynsMKTGIbpvRs0Sh78--
