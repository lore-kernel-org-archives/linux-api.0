From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 4/7] Teach SELinux about a new userfaultfd class
Date: Sat, 12 Oct 2019 16:08:54 -0700
Message-ID: <CALCETrVmYQ9xikif--RSAWhboY1yj=piEAEuPzisf+b+qEX4uA@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-5-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-5-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, lokeshgidra@google.com, Nick Kralevich <nnk@google.com>, nosh@google.com, Tim Murray <timmurray@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 12:16 PM Daniel Colascione <dancol@google.com> wrote:
>
> Use the secure anonymous inode LSM hook we just added to let SELinux
> policy place restrictions on userfaultfd use. The create operation
> applies to processes creating new instances of these file objects;
> transfer between processes is covered by restrictions on read, write,
> and ioctl access already checked inside selinux_file_receive.

This is great, and I suspect we'll want it for things like SGX, too.
But the current design seems like it will make it essentially
impossible for SELinux to reference an anon_inode class whose
file_operations are in a module, and moving file_operations out of a
module would be nasty.

Could this instead be keyed off a new struct anon_inode_class, an
enum, or even just a string?

--Andy
