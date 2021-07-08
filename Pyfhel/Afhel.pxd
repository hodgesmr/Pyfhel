# distutils: language = c++
# distutils: sources = ../SEAL/SEAL/seal/plaintext.cpp ../SEAL/SEAL/seal/ciphertext.cpp ../Afhel/Afseal.cpp
#cython: language_level=3, boundscheck=False

# -------------------------------- IMPORTS ------------------------------------
# Import from Cython libs required C/C++ types for the Afhel API
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp.complex cimport complex as c_complex
from libcpp cimport bool
from numpy cimport int64_t, uint64_t
        
# Import our own wrapper for iostream classes, used for I/O ops
from Pyfhel.iostream cimport istream, ostream, ifstream, ofstream       

ctypedef c_complex[double] cy_complex

# --------------------------- EXTERN DECLARATION ------------------------------
# SEAL plaintext class        
cdef extern from "seal/plaintext.h" namespace "seal" nogil:
    cdef cppclass Plaintext:
        Plaintext() except +
        Plaintext(const Plaintext &copy) except +
        bool is_zero() except +
        string to_string() except +
        
# SEAL ciphertext class        
cdef extern from "seal/ciphertext.h" namespace "seal" nogil:
    cdef cppclass Ciphertext:
        Ciphertext() except +
        Ciphertext(const Ciphertext &copy) except +
        int size_capacity() except +
        int size() except +

# Afseal class to abstract SEAL
cdef extern from "Afhel/Afseal.h" nogil:
    cdef cppclass Afseal:
        # ----------------------- OBJECT MANAGEMENT ---------------------------
        Afseal() except +
        Afseal(const Afseal &otherAfseal) except +
        Afseal(Afseal &&source) except +

        # -------------------------- CRYPTOGRAPHY -----------------------------
        # CONTEXT & KEY GENERATION
        void ContextGen(long p, long m, bool flagBatching, long base,
                 long sec, int intDigits, int fracDigits) except +
        void KeyGen() except +

        # ENCRYPTION
        Ciphertext encrypt(Plaintext& plain1) except +
        Ciphertext encrypt(double& value1) except +
        Ciphertext encrypt(int64_t& value1) except +
        Ciphertext encrypt(vector[int64_t]& valueV) except +
        vector[Ciphertext] encrypt(vector[int64_t]& valueV, bool& dummy_NoBatch) except +
        vector[Ciphertext] encrypt(vector[double]& valueV) except +
        
        void encrypt(Plaintext& plain1, Ciphertext& cipherOut) except +
        void encrypt(double& value1, Ciphertext& cipherOut) except +
        void encrypt(int64_t& value1, Ciphertext& cipherOut) except +
        void encrypt(vector[int64_t]& valueV, Ciphertext& cipherOut) except +
        void encrypt(vector[int64_t]& valueV, vector[Ciphertext]& cipherOut) except +
        void encrypt(vector[double]& valueV, vector[Ciphertext]& cipherOut) except +

        # DECRYPTION
        vector[int64_t] decrypt(Ciphertext& cipher1) except +

        void decrypt(Ciphertext& cipher1, Plaintext& plainOut) except +
        void decrypt(Ciphertext& cipher1, int64_t& valueOut) except + 
        void decrypt(Ciphertext& cipher1, double& valueOut) except +
        void decrypt(Ciphertext& cipher1, vector[int64_t]& valueVOut) except + 
        void decrypt(vector[Ciphertext]& cipherV, vector[int64_t]& valueVOut) except +
        void decrypt(vector[Ciphertext]& cipherV, vector[double]& valueVOut) except +

        # NOISE LEVEL
        int noiseLevel(Ciphertext& cipher1) except +

        # ------------------------------ CODEC --------------------------------
        # ENCODE
        Plaintext encode(int64_t& value1) except +
        Plaintext encode(double& value1) except +
        Plaintext encode(vector[int64_t] &values) except +
        vector[Plaintext] encode(vector[int64_t] &values, bool dummy_NoBatch) except +
        vector[Plaintext] encode(vector[double] &values) except +

        void encode(int64_t& value1, Plaintext& plainOut) except +
        void encode(double& value1, Plaintext& plainOut) except +
        void encode(vector[int64_t] &values, Plaintext& plainOut) except +
        void encode(vector[int64_t] &values, vector[Plaintext]& plainVOut) except +
        void encode(vector[double] &values, vector[Plaintext]& plainVOut) except +
        
        # DECODE 
        vector[int64_t] decode(Plaintext& plain1) except +
        
        void decode(Plaintext& plain1, double& valOut) except +
        void decode(Plaintext& plain1, vector[int64_t] &valueVOut) except +
        void decode(vector[Plaintext]& plain1, vector[int64_t] &valueVOut) except +
        void decode(vector[Plaintext]& plain1, vector[double] &valueVOut) except +

        # -------------------------- OTHER OPERATIONS -------------------------
        void rotateKeyGen(int& bitCount) except +
        void relinKeyGen(int& bitCount, int& size) except +
        void relinearize(Ciphertext& cipher1) except +

        # ---------------------- HOMOMORPHIC OPERATIONS -----------------------
        void square(Ciphertext& cipher1) except +
        void square(vector[Ciphertext]& cipherV) except +
        void negate(Ciphertext& cipher1) except +
        void negate(vector[Ciphertext]& cipherV) except +
        void add(Ciphertext& cipher1, Ciphertext& cipher2) except +
        void add(Ciphertext& cipher1, Plaintext& plain2) except +
        void add(vector[Ciphertext]& cipherV, Ciphertext& cipherOut) except +
        void add(vector[Ciphertext]& cipherVInOut, vector[Ciphertext]& cipherV2) except +
        void add(vector[Ciphertext]& cipherVInOut, vector[Plaintext]& plainV2) except +
        void sub(Ciphertext& cipher1, Ciphertext& cipher2) except +
        void sub(Ciphertext& cipher1, Plaintext& plain2) except +
        void sub(vector[Ciphertext]& cipherVInOut, vector[Ciphertext]& cipherV2) except +
        void sub(vector[Ciphertext]& cipherVInOut, vector[Plaintext]& plainV2) except +
        void multiply(Ciphertext& cipher1, Ciphertext& cipher2) except +
        void multiply(Ciphertext& cipher1, Plaintext& plain1) except +
        void multiply(vector[Ciphertext]& cipherV1, Ciphertext& cipherOut) except +
        void multiply(vector[Ciphertext]& cipherVInOut, vector[Ciphertext]& cipherV2) except +
        void multiply(vector[Ciphertext]& cipherVInOut, vector[Plaintext]& plainV2) except +
        void rotate(Ciphertext& cipher1, int& k) except +
        void rotate(vector[Ciphertext]& cipherV, int& k) except +
        void exponentiate(Ciphertext& cipher1, uint64_t& expon) except +
        void exponentiate(vector[Ciphertext]& cipherV, uint64_t& expon) except +
        void polyEval(Ciphertext& cipher1, vector[int64_t]& coeffPoly) except +
        void polyEval(Ciphertext& cipher1, vector[double]& coeffPoly) except +

        # -------------------------------- I/O --------------------------------
        # With files
        bool saveContext(string fileName) except +
        bool restoreContext(string fileName) except +
        
        bool savepublicKey(string fileName) except +
        bool restorepublicKey(string fileName) except +
        
        bool savesecretKey(string fileName) except +
        bool restoresecretKey(string fileName) except +
        
        bool saverelinKey(string fileName) except +
        bool restorerelinKey(string fileName) except +
        
        bool saverotateKey(string fileName) except +
        bool restorerotateKey(string fileName) except +

        bool savePlaintext(string fileName, Plaintext& plain) except +
        bool restorePlaintext(string fileName, Plaintext& plain) except +

        bool saveCiphertext(string fileName, Ciphertext& ctxt) except +
        bool restoreCiphertext(string fileName, Ciphertext& ctxt) except +

        # With Streams
        bool ssaveContext(ostream& contextFile) except +
        bool srestoreContext(istream& contextFile) except +
        
        bool ssavepublicKey(ostream& keyFile) except +
        bool srestorepublicKey(istream& keyFile) except +
        
        bool ssavesecretKey(ostream& keyFile) except +
        bool srestoresecretKey(istream& keyFile) except +
        
        bool ssaverelinKey(ostream& keyFile) except +
        bool srestorerelinKey(istream& keyFile) except +
        
        bool ssaverotateKey(ostream& keyFile) except +
        bool srestorerotateKey(istream& keyFile) except +
        
        bool srestorePlaintext(istream& plaintextFile, Plaintext& plain) except +
        bool ssavePlaintext(ostream& plaintextFile, Plaintext& plain)except +

        bool ssaveCiphertext(ostream& ctxtFile, Ciphertext& ctxt) except +
        bool srestoreCiphertext(istream& ctxtFile, Ciphertext& ctxt) except +
        # ----------------------------- AUXILIARY -----------------------------
        bool batchEnabled() except +
        long relinBitCount() except +

        # GETTERS
        int getnSlots() except +
        int getp() except +
        int getm() except +
        int getbase() except +
        int getsec() except + 
        int getintDigits() except +
        int getfracDigits() except +
        bool getflagBatch() except +
        bool is_secretKey_empty() except+
        bool is_publicKey_empty() except+
        bool is_rotKey_empty() except+
        bool is_relinKey_empty() except+
        bool is_context_empty() except+

        # POLY
        # Construction
        AfsealPoly empty_poly(Ciphertext &ref) except+
        AfsealPoly poly_from_ciphertext(Ciphertext &ctxt, size_t i) except+
        AfsealPoly poly_from_plaintext(Ciphertext &ref, Plaintext &ptxt) except+
        AfsealPoly poly_from_coeff_vector(vector[cy_complex] &coeff_vector, Ciphertext &ref) except+
        vector[AfsealPoly] poly_from_ciphertext(Ciphertext &ref) except+

        # Ops
        AfsealPoly add(AfsealPoly &p1, AfsealPoly &p2) except+
        AfsealPoly subtract(AfsealPoly &p1, AfsealPoly &p2) except+
        AfsealPoly multiply(AfsealPoly &p1, AfsealPoly &p2) except+
        AfsealPoly invert(AfsealPoly &p) except+

        # inplace ops -> result in first operand
        void add_inplace(AfsealPoly &p1, AfsealPoly &p2) except+
        void subtract_inplace(AfsealPoly &p1, AfsealPoly &p2) except+
        void multiply_inplace(AfsealPoly &p1, AfsealPoly &p2) except+
        bool invert_inplace(AfsealPoly &p) except+

        # I/O
        void poly_to_ciphertext(AfsealPoly &p, Ciphertext &ctxt, size_t i) except+
        void poly_to_plaintext(AfsealPoly &p, Plaintext &ptxt) except+

    # Afseal class to abstract internal polynoms
    cdef cppclass AfsealPoly:
        AfsealPoly(Afseal &afseal, const Ciphertext &ref) except+
        AfsealPoly(AfsealPoly &other) except+
        AfsealPoly(Afseal &afseal, Ciphertext &ctxt, size_t index) except+
        AfsealPoly(Afseal &afseal, Plaintext &ptxt, const Ciphertext &ref) except+

        vector[cy_complex] to_coeff_list() except+

        cy_complex get_coeff(int64_t i) except+
        void set_coeff(cy_complex&val, size_t i) except+
        size_t get_coeff_count() except+
        size_t get_coeff_modulus_count() except+