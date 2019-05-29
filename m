From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring
 buffer [ver #13]
Date: Wed, 29 May 2019 09:55:38 +0200
Message-ID: <CAJfpeguPTQ00zVjpwVQ4R8mEqE3aijCzNMAz6Wvr56xE-jfJag@mail.gmail.com>
References: <155905621951.1304.5956310120238620025.stgit@warthog.procyon.org.uk>
 <155905622921.1304.8775688192987027250.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905622921.1304.8775688192987027250.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 5:10 PM David Howells <dhowells@redhat.com> wrote:
>
> Implement a misc device that implements a general notification queue as a
> ring buffer that can be mmap()'d from userspace.
>
> The way this is done is:
>
>  (1) An application opens the device and indicates the size of the ring
>      buffer that it wants to reserve in pages (this can only be set once):
>
>         fd = open("/dev/watch_queue", O_RDWR);
>         ioctl(fd, IOC_WATCH_QUEUE_NR_PAGES, nr_of_pages);
>
>  (2) The application should then map the pages that the device has
>      reserved.  Each instance of the device created by open() allocates
>      separate pages so that maps of different fds don't interfere with one
>      another.  Multiple mmap() calls on the same fd, however, will all work
>      together.
>
>         page_size = sysconf(_SC_PAGESIZE);
>         mapping_size = nr_of_pages * page_size;
>         char *buf = mmap(NULL, mapping_size, PROT_READ|PROT_WRITE,
>                          MAP_SHARED, fd, 0);

Would it make sense to use relayfs for the implementation of the
mapped ring buffer?

Thanks,
Miklos
