From: Daniel Colascione <dancol@google.com>
Subject: Official Linux system wrapper library?
Date: Sat, 10 Nov 2018 10:52:06 -0800
Message-ID: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Now that glibc is basically not adding any new system call wrappers,
how about publishing an "official" system call glue library as part of
the kernel distribution, along with the uapi headers? I don't think
it's reasonable to expect people to keep using syscall(__NR_XXX) for
all new functionality, especially as the system grows increasingly
sophisticated capabilities (like the new mount API, and hopefully the
new process API) outside the strictures of the POSIX process.
