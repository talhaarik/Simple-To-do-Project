import Array "mo:base/Array";
import Debug "mo:base/Debug";

actor ISG_RBAC {
    // Kullanıcı rolleri
    public type Role = {
        #Admin;
        #Manager;
        #Employee;
    };

    // Kullanıcı yapısı
    public type User = {
        id: Nat;
        name: Text;
        role: Role;
    };

    // Kullanıcılar listesi
    var users: [User] = [];

    // Kullanıcı ekleme fonksiyonu
    public func addUser(id: Nat, name: Text, role: Role) : async () {
        let newUser: User = {
            id = id;
            name = name;
            role = role;
        };
        users := Array.append<User>(users, [newUser]);
    };

    // Kullanıcı rolü kontrol fonksiyonu
    public func checkUserRole(id: Nat, requiredRole: Role) : async Bool {
        for (user in users.vals()) {
            if (user.id == id) {
                return user.role == requiredRole;
            }
        };
        return false;
    };

    // İş Sağlığı Güvenliği raporu oluşturma (sadece Admin)
    public func createSafetyReport(id: Nat, report: Text) : async ?Text {
        let isAdmin = await checkUserRole(id, #Admin);
        if (isAdmin) {
            return ?("Rapor oluşturuldu: " # report);
        } else {
            return null;
        }
    };

    // İş Sağlığı Güvenliği raporu görüntüleme (Manager ve Admin)
    public func viewSafetyReport(id: Nat) : async ?Text {
        let isAdmin = await checkUserRole(id, #Admin);
        let isManager = await checkUserRole(id, #Manager);
        if (isAdmin or isManager) {
            return ?("İSG Raporu: [Örnek Rapor]");
        } else {
            return null;
        }
    };

    // Kullanıcı işlemlerini test etme
    public func test() : async () {
        await addUser(1, "Ali", #Admin);
        await addUser(2, "Ayşe", #Manager);
        await addUser(3, "Mehmet", #Employee);

        let adminReport = await createSafetyReport(1, "Yeni İSG raporu");
        let managerReport = await viewSafetyReport(2);
        let employeeReport = await viewSafetyReport(3);

        Debug.print(debug_show(adminReport));
        Debug.print(debug_show(managerReport));
        Debug.print(debug_show(employeeReport));
    };
};