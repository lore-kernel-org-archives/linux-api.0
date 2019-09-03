From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 11/11] smack: Implement the watch_key and
 post_notification hooks [untested] [ver #7]
Date: Tue, 3 Sep 2019 10:40:05 -0700
Message-ID: <87bf0363-af77-1e5a-961f-72730e39e3a6@schaufler-ca.com>
References: <e36fa722-a300-2abf-ae9c-a0246fc66d0e@schaufler-ca.com>
 <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717352917.2204.17206219813087348132.stgit@warthog.procyon.org.uk>
 <4910.1567525310@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4910.1567525310@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 9/3/2019 8:41 AM, David Howells wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> I tried running your key tests and they fail in "keyctl/move/valid",
>> with 11 FAILED messages, finally hanging after "UNLINK KEY FROM SESSION".
>> It's possible that my Fedora26 system is somehow incompatible with the
>> tests. I don't see anything in your code that would cause this, as the
>> Smack policy on the system shouldn't restrict any access.
> Can you go into keyutils/tests/keyctl/move/valid/ and grab the test.out file?

Inline below

> I presume you're running with an upstream-ish kernel

Built from your tree. It's possible I've missed an important
CONFIG or two.

>  and a cutting edge
> keyutils installed?

Also built from your tree. 

>
> David

$ cat test.out
++++ BEGINNING TEST
+++ ADD KEYRING
keyctl newring wibble @s
1065401533
+++ ADD KEY
keyctl add user lizard gizzard 1065401533
483362336
+++ LIST KEYRING WITH ONE
keyctl rlist 1065401533
483362336
+++ MOVE KEY 1
keyctl move 483362336 1065401533 @s
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ CHECK KEY LINKAGE
keyctl rlist @s
1065401533
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ CHECK KEY REMOVED
keyctl rlist 1065401533
483362336
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ MOVE KEY 2
keyctl move 483362336 1065401533 @s
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ FORCE MOVE KEY 2
keyctl move -f 483362336 1065401533 @s
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ MOVE KEY 3
keyctl move 483362336 @s 1065401533
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ MOVE KEY 4
keyctl move -f 483362336 @s 1065401533
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0       \_ user: lizard
==============
+++ ADD KEY 2
keyctl add user lizard gizzard @s
898499184
+++ MOVE KEY 5
keyctl move 483362336 1065401533 @s
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0   |   \_ user: lizard
 898499184 --alswrv      0     0   \_ user: lizard
==============
+++ CHECK KEY UNMOVED
keyctl rlist 1065401533
483362336
+++ CHECK KEY UNDISPLACED
keyctl rlist @s
1065401533 898499184
+++ FORCE MOVE KEY 6
keyctl move -f 483362336 1065401533 @s
keyctl_move: Operation not supported
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0   |   \_ user: lizard
 898499184 --alswrv      0     0   \_ user: lizard
==============
+++ CHECK KEY REMOVED
keyctl rlist 1065401533
483362336
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0   |   \_ user: lizard
 898499184 --alswrv      0     0   \_ user: lizard
==============
+++ CHECK KEY DISPLACED
keyctl rlist @s
1065401533 898499184
=== FAILED ===
Session Keyring
 680859405 --alswrv      0     0  keyring: RHTS/keyctl/32472
1065401533 --alswrv      0     0   \_ keyring: wibble
 483362336 --alswrv      0     0   |   \_ user: lizard
 898499184 --alswrv      0     0   \_ user: lizard
==============
+++ UNLINK KEY FROM SESSION
keyctl unlink 483362336 @s
+++ WAITING FOR KEY TO BE UNLINKED
keyctl unlink 483362336 @s
keyctl_unlink: No such file or directory
keyctl unlink 483362336 @s
keyctl_unlink: No such file or directory

...
