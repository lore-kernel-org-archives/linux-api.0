From: Bala S <balas2380@gmail.com>
Subject: Suggested Patch is not working for 22851 Bugzilla issue
Date: Tue, 19 Nov 2019 10:37:44 +0530
Message-ID: <CAJKzgVtzD7ULwCDVRSLMCmGJNaMqvx+jVO619t3xuv2oiEsPMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mhocko@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Mhocko,

https://sourceware.org/bugzilla/show_bug.cgi?id=3D22851
For the above issue, I have found the patch.

Patch link:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1561935.html

Only change i noticed is 'MAP_FIXED_NOREPLACE' is used instead of
'MAP_FIXED_SAFE'.

I ran test case on the following targets with this patch:

1. For X86-64, Still i could see the reported issue( 'libevil.so' just
runs =E2=80=98cat /etc/passwd')

2. For MIPS-64, i am not seeing the malicious file content as
reported. But =E2=80=98ldd=E2=80=99 could not found =E2=80=98libevil.so=E2=
=80=99.

root@qemumips64:~/LIN1019-1806# ldd ./main
        linux-vdso.so.1 (0x000000fff1f20000)
        libevil.so =3D> not found
        libc.so.6 =3D> /lib/libc.so.6 (0x0000005e46f70000)
        /lib/ld.so.1 (0x000000fff7888000)

I am not clear why this patch is not working for X86-64? But it is
working for MIPS-64 with some issue.
Please let me know, if anything is pending on this patch for the reported i=
ssue.

Thanks,
Bala
