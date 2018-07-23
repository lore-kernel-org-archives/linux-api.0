From: Michael Tirado <mtirado418@gmail.com>
Subject: Re: [PATCH v6] pidns: introduce syscall translate_pid
Date: Mon, 23 Jul 2018 20:55:41 +0000
Message-ID: <CAMkWEXPTb2NJH5rv8WpKWQaZVOJZp91z5Rr-e19UjrwBxB2pNw@mail.gmail.com>
References: <152788068212.768348.15192457501079586650.stgit@buzz> <db8d560e-47d1-c32f-e4a2-407110f2b5b6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db8d560e-47d1-c32f-e4a2-407110f2b5b6@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Prakash Sangappa <prakash.sangappa@oracle.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Hey, I'm not seeing much activity on this so here's my $0.02

> Unix socket automatically translates pid attached to SCM_CREDENTIALS.
> This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
> into pid namespace, this expose process and could be insecure.


Perhaps it would be a good idea to add a sysctl switch that prevents
credential spoofing over AF_UNIX \by default\ if that is the main
concern, or is there another concern and I have read this wrong?  I'm
having trouble thinking of a legitimate use of SCM_CREDENTIALS
spoofing that isn't in a debugging or troubleshooting context and
would be more comfortable if it were not possible at all... Anyone
know of a program that relies on this spoofing functionality?

If you look at socket(7) under SO_PEERCRED there is a way to get
credentials at time of connect() for an AF_UNIX SOCK_STREAM, or at
time of socketpair() for a SOCK_DGRAM. I would like to think these
credentials are reliable, but will probably require some extra daemon
to proxy a dgram syslog socket.
