From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications [ver #3]
Date: Thu, 06 Jun 2019 23:38:01 +0100
Message-ID: <30567.1559860681@warthog.procyon.org.uk>
References: <AD7898AE-B92C-4DE6-B895-7116FEDB3091@amacapital.net> <CALCETrVuNRPgEzv-XY4M9m6sEsCiRHxPenN_MpcMYc1h26vVwQ@mail.gmail.com> <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <3813.1559827003@warthog.procyon.org.uk> <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov> <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com> <c82052e5-ca11-67b5-965e-8f828081f31c@tycho.nsa.gov> <07e92045-2d80-8573-4d36-643deeaff9ec@schaufler-ca.com> <23611.1559855827@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AD7898AE-B92C-4DE6-B895-7116FEDB3091@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> I mean: are there cases where some action generates a notification but does
> not otherwise have an effect visible to the users who can receive the
> notification. It looks like the answer is probably “no”, which is good.

mount_notify().  You can get a notification that someone altered the mount
topology (eg. by mounting something).  A process receiving a notification
could then use fsinfo(), say, to reread the mount topology tree, find out
where the new mount is and wander over there to have a look - assuming they
have the permissions for pathwalk to succeed.

David
