From: Christian Brauner <christian@brauner.io>
Subject: [RFC]: Convention for naming syscall revisions
Date: Thu, 6 Jun 2019 17:42:25 +0200
Message-ID: <20190606154224.7lln4zp6v3ey4icq@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hey everyone,

I hope this is not going to start a trash fire.

While working on a new clone version I tried to find out what the
current naming conventions for syscall revisions is. I was told and
seemed to be able to confirm through the syscall list that revisions of
syscalls are for the most part (for examples see [1]) named after the
number of arguments and not for the number of revisions. But some also
seem to escape that logic (e.g. clone2).

In any case, I would like to document *a* convention for syscall
revisions on https://www.kernel.org/doc/ . So what shall it be:
- number of args
- number of revision
?

Christian

[1]: - accept4(/* 4 args */)
     - dup2(/* 2 args */)
     - dup3(/* 3 args */)
     - eventfd2(/* 2 args */)
     - pipe2(/* 2 args */)
     - pselect6(/* 6 args, including structs */)
     - signalfd4(/* 4 args, one of them a struct */)
     - umount2(/* 2 args */)
     - wait3(/* 3 args, one of them a struct */)
     - wait4(/* 4 args, one of them a struct */)
